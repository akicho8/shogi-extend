# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報 (swars_battles as Swars::Battle)
#
# |-------------------+------------------+-------------+-------------+------+-------|
# | name              | desc             | type        | opts        | refs | index |
# |-------------------+------------------+-------------+-------------+------+-------|
# | id                | ID               | integer(8)  | NOT NULL PK |      |       |
# | key               | 対局ユニークキー | string(255) | NOT NULL    |      | A!    |
# | battled_at        | 対局日時         | datetime    | NOT NULL    |      |       |
# | rule_key          | ルール           | string(255) | NOT NULL    |      | B     |
# | csa_seq           | 棋譜             | text(65535) | NOT NULL    |      |       |
# | final_key         | 結末             | string(255) | NOT NULL    |      | C     |
# | win_user_id       | 勝者             | integer(8)  |             |      | D     |
# | turn_max          | 手数             | integer(4)  | NOT NULL    |      |       |
# | meta_info         | メタ情報         | text(65535) | NOT NULL    |      |       |
# | last_accessd_at   | 最終アクセス日時 | datetime    | NOT NULL    |      |       |
# | access_logs_count | アクセス数       | integer(4)  | DEFAULT(0)  |      |       |
# | created_at        | 作成日時         | datetime    | NOT NULL    |      |       |
# | updated_at        | 更新日時         | datetime    | NOT NULL    |      |       |
# | preset_key        | 手合割           | string(255) | NOT NULL    |      |       |
# |-------------------+------------------+-------------+-------------+------+-------|

module Swars
  class BattlesController < ApplicationController
    include ModulableCrud::All
    include SharedMethods

    let :current_mode do
      (params[:mode].presence || "basic").to_sym
    end

    let :current_placeholder do
      "ウォーズID・対局URL・タグのどれかを入力してください"
    end

    let :current_records do
      current_scope.page(params[:page]).per(params[:per] || default_per)
    end

    let :default_per do
      if current_mode == :basic
        9
      else
        50
      end
    end

    let :rows do
      current_records.collect(&method("row_build_for_#{current_mode}"))
    end

    let :current_swars_user do
      User.find_by(user_key: current_user_key)
    end

    let :current_query_hash do
      if e = [:query].find { |e| params[e].present? }
        acc = {}
        str = params[e].to_s.gsub(/\p{blank}/, " ").strip
        str.split.each do |s|
          if s.match?(/\A(tag):/i) || zenkaku_query?(s)
            acc[:tags] ||= []
            acc[:tags] << s.remove("tag:")
          else
            # https://shogiwars.heroz.jp/users/history/foo?gtype=&locale=ja -> foo
            # https://shogiwars.heroz.jp/users/foo                          -> foo
            if true
              if url = URI::Parser.new.extract(s).first
                uri = URI(url)
                if md = uri.path.match(%r{/users/history/(.*)|/users/(.*)})
                  s = md.captures.compact.first
                end
                logger.info([url, s].to_t)
              end
            end
            acc[:user_key] ||= []
            acc[:user_key] << s
          end
        end
        acc
      end
    end

    let :current_tags do
      if v = current_query_hash
        v[:tags]
      end
    end

    let :current_user_key do
      if v = current_query_hash
        if v = v[:user_key]
          v.first
        end
      end
    end

    let :current_form_search_value do
      if current_query_hash
        current_query_hash.values.join(" ")
      end
    end

    let :current_scope do
      s = current_model.all

      if current_swars_user
        s = s.joins(:memberships => :user)
        s = s.merge(User.where(id: current_swars_user.id))
      end

      if current_tags
        s = s.tagged_with(current_tags)
      end

      s.order(battled_at: :desc)
    end

    let :current_record do
      if v = params[:id].presence
        current_model.single_battle_import(v)
        current_scope.find_by!(key: v)
      else
        current_scope.new
      end
    end

    def index
      if bot_agent?
        return
      end

      if params[:stop_processing_because_it_is_too_heavy]
        return
      end

      if params[:redirect_to_bookmarkable_page]
        flash[:external_app_exec_skip_once] = true # ブックマークできるように一時的にぴよ将棋に飛ばないようにする
        redirect_to [:swars, current_mode, query: current_swars_user, latest_open_index: params[:latest_open_index]]
        return
      end

      # 検索窓に将棋ウォーズへ棋譜URLが指定されたときは詳細に飛ばす
      if query = params[:query].presence
        if key = Battle.extraction_key_from_dirty_string(query)
          redirect_to [:swars, :battle, id: key]
          return
        end
      end

      if current_user_key && params[:page].blank?
        before_count = 0
        if current_swars_user
          before_count = current_swars_user.battles.count
        end

        # 連続クロール回避 (fetchでは Rails.cache.write が後処理のためダメ)
        success = Battle.debounce_basic_import(user_key: current_user_key)
        if !success
          # development でここが通らない
          # development では memory_store なのでリロードが入ると Rails.cache.exist? がつねに false を返している……？
          flash.now[:warning] = "#{current_user_key} さんの棋譜は数秒前に取得したばかりです"
        end
        if success
          remove_instance_variable(:@current_swars_user) # 【重要】 let のキャッシュを破棄するため

          hit_count = 0
          if current_swars_user
            hit_count = current_swars_user.battles.count - before_count
            if hit_count.zero?
              # flash.now[:warning] = "#{current_user_key} さんの新しい棋譜は見つかりませんでした"
            else
              flash.now[:info] = "#{hit_count}件新しく見つかりました"
            end
            current_swars_user.search_logs.create!
          else
            flash.now[:warning] = "#{current_user_key} さんの棋譜は見つかりませんでした。ID が間違っている可能性があります"
          end

          if hit_count.nonzero?
            SlackAgent.chat_post_message(key: "ウォーズ検索#{current_mode.upcase[0]}", body: "#{current_user_key} #{hit_count}件")
          end
        end

        unless flash[:external_app_exec_skip_once]
          if latest_open_index = params[:latest_open_index].presence
            limit = [latest_open_index.to_i.abs, 10].min.next
            if record = current_scope.order(battled_at: :desc).limit(limit).last
              url = piyo_shogi_app_url(full_url_for([record, format: "kif"]))
              SlackAgent.chat_post_message(key: "最新ぴよ将棋", body: current_user_key)
              redirect_to url
              return
            end
          end
        end
      end

      perform_zip_download
      if performed?
        return
      end

      if current_swars_user
        @page_title ||= ["将棋ウォーズ棋譜検索", current_swars_user.user_key]
      end
    end

    def zenkaku_query?(s)
      s.match?(/[\p{Hiragana}\p{Katakana}\p{Han}]/) # 長音符は無視
    end

    rescue_from "Mechanize::ResponseCodeError" do |exception|
      message = "該当のユーザーが見つからないか混み合っています"
      flash.now[:danger] = %(<div class="has-text-weight-bold">#{message}</div><br/>#{exception.class.name}<br/>#{exception.message}<br/><br/>#{exception.backtrace.take(8).join("<br/>")}).html_safe
      render :index
    end

    private

    def access_log_create
      current_record.access_logs.create!
    end

    def versus_tag(*list)
      if !list.compact.empty?
        vs = tag.span(" vs ", :class => "text-muted")
        list.collect { |e| e || "不明" }.join(vs).html_safe
      end
    end

    def tag_links(tag_list)
      if tag_list.present?
        tag_list.collect { |e| link_to(e, swars_search_path(e)) }.join(" ").html_safe
      end
    end

    def row_links(current_record)
      list = []
      list << link_to("コピー".html_safe, "#", "class": "button is-small kif_clipboard_copy_button", data: {kif_direct_access_path: url_for([current_record, format: "kif"])})
      list << link_to("ウォーズ", swars_real_battle_url(current_record), "class": "button is-small", target: "_blank", data: {toggle: :tooltip, title: "将棋ウォーズ"})
      list << link_to("詳細", [current_record], "class": "button is-small")
      list << link_to(h.image_tag("piyo_shogi_app.png", "class": "row_piyo_link"), piyo_shogi_app_url(full_url_for([current_record, format: "kif"])))
      list.compact.join(" ").html_safe
    end

    def user_link(record, judge_key)
      if membership = record.memberships.judge_key_eq(judge_key)
        user_link2(membership)
      end
    end

    def user_link2(membership)
      link_to(membership.name_with_grade, polymorphic_path(membership.user, current_mode: current_mode))
    end

    def final_info_decorate(record)
      e = record.final_info
      str = e.name
      if v = e.label_key
        str = tag.span(str, "class": "text-#{v}")
      end
      str
    end

    def perform_zip_download
      if request.format.zip?
        filename = -> {
          parts = []
          parts << "shogiwars"
          if current_swars_user
            parts << current_swars_user.user_key
          end
          parts << Time.current.strftime("%Y%m%d%H%M%S")
          if current_tags
            parts.concat(current_tags)
          end
          parts.compact.join("_") + ".zip"
        }

        zip_buffer = Zip::OutputStream.write_buffer do |zos|
          current_scope.limit(zip_download_limit).each do |battle|
            KifuFormatWithBodInfo.each.with_index do |e|
              if kd = battle.to_cached_kifu(e.key)
                zos.put_next_entry("#{e.key}/#{battle.key}.#{e.key}")
                zos.write kd
              end
            end
          end
        end

        send_data(zip_buffer.string, type: Mime[params[:format]], filename: filename.call, disposition: "attachment")
      end
    end

    def row_build_for_basic(record)
      {}.tap do |row|
        l_ship, r_ship = left_right_pairs(record)
        left_right_pairs2(row, record, l_ship, r_ship)

        row["結果"] = link_to(final_info_decorate(record), swars_search_path(record.final_info.name))

        if false
          row["戦法"] = record.tag_list.collect { |e| link_to(e, swars_search_path(e)) }.join(" ").html_safe
        else
          # row["戦型"] = versus_tag(tag_links(l_ship.attack_tag_list), tag_links(r_ship.attack_tag_list))
          # row["囲い"] = versus_tag(tag_links(l_ship.defense_tag_list), tag_links(r_ship.defense_tag_list))
        end

        row["手数"] = record.turn_max
        row["種類"] = link_to(record.rule_info.name, swars_search_path(record.rule_info.name))

        row["日時"] = record.battled_at.to_s(:battle_time)

        row[""] = row_links(record)
      end
    end

    def row_build_for_light(record)
      {}.tap do |row|
        row["日時"] = record.battled_at.to_s(:battle_time)

        l_ship, r_ship = left_right_pairs(record)
        left_right_pairs2(row, record, l_ship, r_ship)

        row[""] = link_to(h.image_tag("piyo_shogi_app.png", "class": "row_piyo_link"), piyo_shogi_app_url(full_url_for([record, format: "kif"])))
      end
    end

    def left_right_pairs(record)
      if current_swars_user
        l_ship = record.myself(current_swars_user)
        r_ship = record.rival(current_swars_user)
      else
        if record.win_user
          l_ship = record.memberships.judge_key_eq(:win)
          r_ship = record.memberships.judge_key_eq(:lose)
        else
          l_ship = record.memberships.black
          r_ship = record.memberships.white
        end
      end
      [l_ship, r_ship]
    end

    def left_right_pairs2(row, record, l_ship, r_ship)
      if current_swars_user
        row["対象プレイヤー"] = record.win_lose_str(l_ship.user).html_safe + " " + user_link2(l_ship)
        row["対戦相手"]       = record.win_lose_str(r_ship.user).html_safe + " " + user_link2(r_ship)
      else
        if record.win_user
          row["勝ち"] = icon_tag(:fas, :crown, class: :icon_o) + user_link2(l_ship)
            row["負け"] = icon_tag(:fas, :times, class: :icon_x) + user_link2(r_ship)
            else
              row["勝ち"] = icon_tag(:fas, :minus, :class => "icon_hidden") + user_link2(l_ship)
              row["負け"] = icon_tag(:fas, :minus, :class => "icon_hidden") + user_link2(r_ship)
            end
          end
        end

        def slow_processing_error_redirect_url
          [:swars, :basic, query: current_form_search_value, stop_processing_because_it_is_too_heavy: 1]
        end
      end
    end
