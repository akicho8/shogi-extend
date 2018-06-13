# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報テーブル (battle_records as Swars::BattleRecord)
#
# |---------------------------------------+---------------------------------------+-------------+-------------+-----------------------+-------|
# | カラム名                              | 意味                                  | タイプ      | 属性        | 参照                  | INDEX |
# |---------------------------------------+---------------------------------------+-------------+-------------+-----------------------+-------|
# | id                                    | ID                                    | integer(8)  | NOT NULL PK |                       |       |
# | battle_key                            | Battle key                            | string(255) | NOT NULL    |                       | A!    |
# | battled_at                            | Battled at                            | datetime    | NOT NULL    |                       |       |
# | battle_rule_key                       | Battle rule key                       | string(255) | NOT NULL    |                       | B     |
# | csa_seq                               | Csa seq                               | text(65535) | NOT NULL    |                       |       |
# | battle_state_key                      | Battle state key                      | string(255) | NOT NULL    |                       | C     |
# | win_battle_user_id              | Win swars battle user                 | integer(8)  |             | => Swars::BattleUser#id | D     |
# | turn_max                              | 手数                                  | integer(4)  | NOT NULL    |                       |       |
# | meta_info                             | 棋譜ヘッダー                          | text(65535) | NOT NULL    |                       |       |
# | mountain_url                          | 将棋山脈URL                           | string(255) |             |                       |       |
# | last_accessd_at                       | Last accessd at                       | datetime    | NOT NULL    |                       |       |
# | battle_record_access_logs_count | Swars battle record access logs count | integer(4)  | DEFAULT(0)  |                       |       |
# | created_at                            | 作成日時                              | datetime    | NOT NULL    |                       |       |
# | updated_at                            | 更新日時                              | datetime    | NOT NULL    |                       |       |
# |---------------------------------------+---------------------------------------+-------------+-------------+-----------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・【警告:リレーション欠如】Swars::BattleUserモデルで has_many :battle_records されていません
#--------------------------------------------------------------------------------

module Swars
  class BattleRecordsController < ApplicationController
    include ModulableCrud::All
    include SharedMethods

    def current_model
      ::Swars::BattleRecord
    end

    def index
      unless bot_agent?
        # 検索窓に将棋ウォーズへ棋譜URLが指定されたときは詳細に飛ばす
        if query = params[:query].presence
          if query.match?(%r{https?://kif-pona.heroz.jp/games/})
            battle_key = URI(query).path.split("/").last
            redirect_to [:swars, :battle_record, id: battle_key]
            return
          end
        end

        if current_user_key
          before_count = 0
          if battle_user = ::Swars::BattleUser.find_by(user_key: current_user_key)
            before_count = battle_user.battle_records.count
          end

          # 連続クロール回避 (fetchでは Rails.cache.write が後処理のためダメ)
          key = "basic_import_#{current_user_key}"
          if !Rails.cache.exist?(key)
            Rails.cache.write(key, true, expires_in: Rails.env.production? ? 30.seconds : 0.seconds)
            current_model.basic_import(user_key: current_user_key)
          end

          @battle_user = ::Swars::BattleUser.find_by(user_key: current_user_key)
          if @battle_user
            count_diff = @battle_user.battle_records.count - before_count
            if count_diff.zero?
            else
              flash.now[:info] = "#{count_diff}件新しく見つかりました"
            end
            @battle_user.battle_user_receptions.create!
          else
            flash.now[:warning] = "#{current_user_key} さんのデータは見つかりませんでした"
          end
        end

        perform_zip_download
        if performed?
          return
        end
      end

      self.current_records = current_scope.page(params[:page]).per(params[:per] || 9)

      @rows = current_records.collect { |record| row_build(record) }
    end

    def current_query_hash
      @current_query_hash ||= -> {
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
      }.call
    end

    def current_tags
      if v = current_query_hash
        v[:tags]
      end
    end

    def current_user_key
      if v = current_query_hash
        if v = v[:user_key]
          v.first
        end
      end
    end

    def zenkaku_query?(s)
      s.match?(/[\p{Hiragana}\p{Katakana}\p{Han}]/) # 長音符は無視
    end

    def current_form_search_value
      if current_query_hash
        current_query_hash.values.join(" ")
      end
    end

    rescue_from "Mechanize::ResponseCodeError" do |exception|
      flash.now[:danger] = %(<div class="has-text-weight-bold">該当のユーザーが見つからないか混み合っています</div><br/>#{exception.class.name}<br/>#{exception.message}<br/><br/>#{exception.backtrace.take(8).join("<br/>")}).html_safe
      render :index
    end

    private

    def access_log_create
      current_record.battle_record_access_logs.create!
    end

    def current_scope
      s = super

      if @battle_user
        s = s.joins(:battle_ships => :battle_user)
        s = s.merge(::Swars::BattleUser.where(id: @battle_user.id))
      end

      if current_tags
        s = s.tagged_with(current_tags)
      end

      s.order(battled_at: :desc)
    end

    def raw_current_record
      if v = params[:id].presence
        current_model.single_battle_import(v)
        current_scope.find_by!(battle_key: v)
      else
        current_scope.new
      end
    end

    def pc_only(v)
      tag.span(v, :class => "visible-lg")
    end

    def versus_tag(*list)
      if !list.compact.empty?
        vs = tag.span(" vs ", :class => "text-muted")
        str = list.collect { |e| e || "不明" }.join(vs).html_safe
        pc_only(str)
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
      if Rails.env.development? && false
        list << link_to("山脈(remote:false)", [current_record, mountain: true, fallback_location: url_for([:s])], "class": "button is-small", remote: false)
      end
      # list << link_to("山", [:swars, current_record, mountain: true], "class": "button is-small", remote: true, data: {toggle: :tooltip, title: "将棋山脈"})
      # list << link_to(h.image_tag("piyo_shogi_app.png", "class": "row_piyo_link"), piyo_shogi_app_url(full_url_for([:swars, current_record, format: "kif"])))
      list.compact.join(" ").html_safe
    end

    def battle_user_link(record, judge_key)
      if battle_ship = record.battle_ships.judge_key_eq(judge_key)
        battle_user_link2(battle_ship)
      end
    end

    def battle_user_link2(battle_ship)
      link_to(battle_ship.name_with_grade, battle_ship.battle_user)
    end

    def swars_battle_state_info_decorate(record)
      e = record.swars_battle_state_info
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
          if @battle_user
            parts << @battle_user.user_key
          end
          parts << Time.current.strftime("%Y%m%d%H%M%S")
          if current_tags
            parts.concat(current_tags)
          end
          parts.compact.join("_") + ".zip"
        }

        zip_buffer = Zip::OutputStream.write_buffer do |zos|
          current_scope.limit(params[:limit] || 512).each do |battle_record|
            KifuFormatInfo.each.with_index do |e|
              if converted_info = battle_record.converted_infos.text_format_eq(e.key).take
                zos.put_next_entry("#{e.key}/#{battle_record.battle_key}.#{e.key}")
                zos.write converted_info.text_body
              end
            end
          end
        end

        send_data(zip_buffer.string, type: Mime[params[:format]], filename: filename.call, disposition: "attachment")
      end
    end

    def row_build(record)
      {}.tap do |row|
        if @battle_user
          l_ship = record.myself(@battle_user)
          r_ship = record.rival(@battle_user)
        else
          if record.win_battle_user
            l_ship = record.battle_ships.judge_key_eq(:win)
            r_ship = record.battle_ships.judge_key_eq(:lose)
          else
            l_ship = record.battle_ships.black
            r_ship = record.battle_ships.white
          end
        end

        if @battle_user
          row["対象プレイヤー"] = record.win_lose_str(l_ship.battle_user).html_safe + " " + link_to(l_ship.name_with_grade, l_ship.battle_user)
          row["対戦相手"]       = record.win_lose_str(r_ship.battle_user).html_safe + " " + link_to(r_ship.name_with_grade, r_ship.battle_user)
        else
          if record.win_battle_user
            row["勝ち"] = icon_tag(:far, :circle) + battle_user_link2(l_ship)
            row["負け"] = icon_tag(:fas, :times)  + battle_user_link2(r_ship)
          else
            row["勝ち"] = icon_tag(:fas, :minus, :class => "icon_hidden") + battle_user_link2(l_ship)
            row["負け"] = icon_tag(:fas, :minus, :class => "icon_hidden") + battle_user_link2(r_ship)
          end
        end

        row["結果"] = link_to(swars_battle_state_info_decorate(record), swars_search_path(record.swars_battle_state_info.name))

        if false
          row["戦法"] = record.tag_list.collect { |e| link_to(e, swars_search_path(e)) }.join(" ").html_safe
        else
          row[pc_only("戦型対決")] = versus_tag(tag_links(l_ship.attack_tag_list), tag_links(r_ship.attack_tag_list))
          # row[pc_only("囲い対決")] = versus_tag(tag_links(l_ship.defense_tag_list), tag_links(r_ship.defense_tag_list))
        end

        row["手数"] = record.turn_max
        row["種類"] = link_to(record.swars_battle_rule_info.name, swars_search_path(record.swars_battle_rule_info.name))

        key = :battle_long
        if record.battled_at >= Time.current.midnight
          key = :battle_short
        end
        row["日時"] = record.battled_at.to_s(key)

        row[""] = row_links(record)
      end
    end
  end
end
