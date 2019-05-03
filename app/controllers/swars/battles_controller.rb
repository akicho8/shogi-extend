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
    include BuefyTableMethods

    prepend_before_action only: :show do
      if bot_agent?
        if v = params[:id].presence
          unless current_scope.where(key: v).exists?
            raise ActionController::RoutingError, "ページが見つかりません(for bot)"
          end
        end
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
        SlackAgent.message_send(key: "ブクマ移動", body: current_user_key)
        flash[:external_app_exec_skip_once] = true # ブックマークできるように一時的にぴよ将棋に飛ばないようにする
        # flash[:primary] = "この状態で「ホーム画面に追加」しておくと開くと同時に最新の対局をぴよ将棋で開けるようになります"
        redirect_to [:swars, current_mode, query: current_swars_user, latest_open_index: params[:latest_open_index]]
        return
      end

      if request.format.json?
        render json: js_current_records.to_json # 【重要】 明示的に to_json することで ActiveModelSerializer での変換の試みを回避する
        return
      end

      # 検索窓に将棋ウォーズへ棋譜URLが指定されたときは詳細に飛ばす
      if query = params[:query].presence
        if key = Battle.extraction_key_from_dirty_string(query)
          redirect_to [:swars, :battle, id: key]
          return
        end
      end

      import_process(flash.now)

      unless flash[:external_app_exec_skip_once]
        if latest_open_limit
          if record = current_scope.order(battled_at: :desc).limit(latest_open_limit).last
            @redirect_url_by_js = piyo_shogi_app_url(full_url_for([record, format: "kif"]))
            SlackAgent.message_send(key: "最新開くぴよ", body: current_user_key)
            if false
              # この方法だと動くけど白紙のページが開いてしまう
              redirect_to @redirect_url_by_js
              return
            else
              # なのでページを開いてから遷移する
            end
          end
        end
      end

      perform_zip_download
      if performed?
        return
      end

      @page_title = ["将棋ウォーズ棋譜検索"]
      if current_swars_user
        @page_title << current_swars_user.user_key
      end
    end

    def show
      # クローラーが古いURLの /w/(user_key) 形式で跳んできたとき対策
      # http://localhost:3000/w/devuser1
      if v = params[:id].presence
        if User.where(user_key: v).exists?
          flash[:import_skip] = true
          redirect_to [:swars, current_mode, query: v], alert: "URLを変更したのでトップにリダイレクトしました。お手数ですが新しい棋譜を取り込むには再度検索してください"
          return
        end
      end

      super
    end

    def create
      import_process(flash)
      flash[:import_skip] = true
      redirect_to [:swars, current_mode, query: current_swars_user]
    end

    def user_link2(membership)
      link_to(membership.name_with_grade, polymorphic_path(membership.user, current_mode: current_mode))
    end

    rescue_from "Mechanize::ResponseCodeError" do |exception|
      message = "該当のユーザーが見つからないか混み合っています"
      flash.now[:danger] = %(<div class="has-text-weight-bold">#{message}</div><br/>#{exception.class.name}<br/>#{exception.message}<br/><br/>#{exception.backtrace.take(8).join("<br/>")}).html_safe
      render :index
    end

    private

    def import_process(flash)
      if import_enable?
        before_count = 0
        if current_swars_user
          before_count = current_swars_user.battles.count
        end

        # 連続クロール回避 (fetchでは Rails.cache.write が後処理のためダメ)
        success = Battle.sometimes_user_import(user_key: current_user_key, page_max: current_page_max)
        if !success
          # development でここが通らない
          # development では memory_store なのでリロードが入ると Rails.cache.exist? がつねに false を返している……？
          flash[:warning] = "#{current_user_key} さんの棋譜はさっき取得したばかりです"
        end
        if success
          let_cache_remove(:current_swars_user)

          hit_count = 0
          if current_swars_user
            hit_count = current_swars_user.battles.count - before_count
            if hit_count.zero?
              # flash[:warning] = "#{current_user_key} さんの新しい棋譜は見つかりませんでした"
            else
              flash[:info] = "#{hit_count}件新しく見つかりました"
            end
            current_swars_user.search_logs.create!
          else
            flash[:warning] = "#{current_user_key} さんの棋譜は見つかりませんでした。ID が間違っている可能性があります"
          end

          if hit_count.nonzero?
            SlackAgent.message_send(key: current_mode == :basic ? "ウォーズ検索" : "ぴよ専用検索", body: "#{current_user_key} #{hit_count}件")
          end
        end
      end
    end

    def import_enable?
      current_user_key && params[:page].blank? && !params[:import_skip] && !flash[:import_skip]
    end

    def current_page_max
      (params[:page_max].presence || 1).to_i
    end

    def zenkaku_query?(s)
      s.match?(/[\p{Hiragana}\p{Katakana}\p{Han}]/) # 長音符は無視
    end

    def access_log_create
      if bot_agent?
        return
      end

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
        tag_list.collect { |e| link_to(e, swars_tag_search_path(e)) }.join(" ").html_safe
      end
    end

    def row_links(current_record)
      list = []

      # list << link_to("コピー".html_safe, "#", "class": "button is-small kif_clipboard_copy_button", data: {kifu_copy_params: current_record.to_kifu_copy_params(self).to_json})

      # list << link_to("コピー".html_safe, "#", "class": "button is-small kif_clipboard_copy_button", data: {kifu_copy_params: current_record.to_kifu_copy_params(self).to_json})
      # list << link_to(icon_tag(:far, :clipboard) + "棋譜コピー", "#", "@click.prevent" => "kifu_copy_handle(props.row)", :class => "button")
      # list << link_to("コピー", "#", "@click.prevent" => "kifu_copy_handle(props.row)", :class => "button is-small")

      # list << link_to("ウォーズ", swars_real_battle_url(current_record), "class": "button is-small", target: "_blank", data: {toggle: :tooltip, title: "将棋ウォーズ"})
      list << link_to("詳細", [current_record], "class": "button is-small")
      if mobile_agent_or_development?
        list << link_to(h.image_tag("piyo_shogi_app.png", "class": "row_piyo_link"), piyo_shogi_app_url(full_url_for([current_record, format: "kif"])))
      end
      list.join(" ")
    end

    # def user_link(record, judge_key)
    #   if membership = record.memberships.judge_key_eq(judge_key)
    #     user_link2(membership)
    #   end
    # end

    def perform_zip_download
      if request.format.zip?
        require "kconv"

        filename = -> {
          parts = []
          parts << "shogiwars"
          if current_swars_user
            parts << current_swars_user.user_key
          end
          parts << Time.current.strftime("%Y%m%d%H%M%S")
          parts << current_encode
          if current_tags
            parts.concat(current_tags)
          end
          str = parts.compact.join("_") + ".zip"
          str.public_send("to#{current_encode}")
        }

        zip_buffer = Zip::OutputStream.write_buffer do |zos|
          current_scope.limit(zip_download_limit).each do |battle|
            Bioshogi::KifuFormatInfo.each.with_index do |e|
              if str = battle.to_cached_kifu(e.key)
                zos.put_next_entry("#{e.key}/#{battle.key}.#{e.key}")
                zos.write(str.public_send("to#{current_encode}"))
              end
            end
          end
        end

        send_data(zip_buffer.string, type: Mime[params[:format]], filename: filename.call, disposition: "attachment")
      end
    end

    def row_build_for_basic(record)
      {}.tap do |row|
        row.update(left_right_pairs2(left_right_pairs(record)))

        row["結果"] = link_to(record.final_info.name, swars_tag_search_path(record.final_info.name), :class => record.final_info.has_text_color)

        if false
          row["戦法"] = record.tag_list.collect { |e| link_to(e, swars_tag_search_path(e)) }.join(" ").html_safe
        else
          # row["戦型"] = versus_tag(tag_links(l_ship.attack_tag_list), tag_links(r_ship.attack_tag_list))
          # row["囲い"] = versus_tag(tag_links(l_ship.defense_tag_list), tag_links(r_ship.defense_tag_list))
        end

        if teai_p
          row["手合"] = link_to(record.preset_info.name, swars_tag_search_path(record.preset_info.name))
        end
        row["手数"] = record.turn_max
        row["種類"] = link_to(record.rule_info.name, swars_tag_search_path(record.rule_info.name))

        row["日時"] = record.battled_at.to_s(:battle_time)

        row[""] = row_links(record)
      end
    end

    def row_build_for_light(record)
      {}.tap do |row|
        row["日時"] = record.battled_at.to_s(:battle_time)
        row.update(left_right_pairs2(left_right_pairs(record)))
        row[""] = link_to(h.image_tag("piyo_shogi_app.png", "class": "row_piyo_link"), piyo_shogi_app_url(full_url_for([record, format: "kif"])))
      end
    end

    def left_right_pairs(record)
      row = {}
      l, r = record.memberships
      if current_swars_user
        if l.user == current_swars_user
          row["対象プレイヤー"] = l
          row["対戦相手"]       = r
        else
          row["対象プレイヤー"] = r
          row["対戦相手"]       = l
        end
      else
        if record.win_user_id
          if l.judge_key == "win"
            row["勝ち"] = l
            row["負け"] = r
          else
            row["勝ち"] = r
            row["負け"] = l
          end
        else
          # 引き分け
          row["勝ち"] = l
          row["負け"] = r
        end
      end
      row
    end

    def left_right_pairs2(row)
      row.transform_values do |e|
        e.icon_html + user_link2(e)
      end
    end

    def slow_processing_error_redirect_url
      [:swars, :basic, query: current_query, stop_processing_because_it_is_too_heavy: 1]
    end

    def swars_tag_search_path(e)
      url_for([:swars, current_mode, query: "tag:#{e}", only_path: true])
    end

    let :current_mode do
      (params[:mode].presence || "basic").to_sym
    end

    let :default_per do
      if current_mode == :basic
        25
      else
        50
      end
    end

    let :current_per do
      params[:per].presence || default_per
    end

    let :rows do
      current_records.collect(&method("row_build_for_#{current_mode}"))
    end

    let :current_swars_user do
      User.find_by(user_key: current_user_key)
    end

    let :current_query_info do
      QueryInfo.parse(current_query)
    end

    let :current_query_hash do
      current_query_info.attributes
    end

    let :current_tags do
      if v = current_query_hash
        v[:tag]
      end
    end

    let :current_musers do
      if v = current_query_hash
        v[:muser]
      end
    end

    let :current_mtags do
      if v = current_query_hash
        v[:mtag]
      end
    end

    let :current_ids do
      if v = current_query_hash
        v[:ids]
      end
    end

    let :current_user_key do
      if s = (current_query_info.values + current_query_info.urls).first
        # https://shogiwars.heroz.jp/users/history/foo?gtype=&locale=ja -> foo
        # https://shogiwars.heroz.jp/users/foo                          -> foo
        if true
          if url = URI::Parser.new.extract(s).first
            uri = URI(url)
            if uri.path
              if md = uri.path.match(%r{/users/history/(.*)|/users/(.*)})
                s = md.captures.compact.first
              end
              logger.info([url, s].to_t)
            end
          end
        end
        ERB::Util.html_escape(s)
      end
    end

    let :current_record do
      if v = params[:id].presence
        current_model.single_battle_import(key: v)
        current_scope.find_by!(key: v)
      else
        current_scope.new
      end
    end

    let :js_swars_show_app_params do
      {
        think_chart_params: {
          type: "line",
          data: {
            labels: (1..current_record.turn_max).to_a,
            datasets: current_record.memberships.collect.with_index { |e, i|
              {
                label: e.name_with_grade,
                data: e.chartjs_data,
                borderColor: PaletteInfo[i].border_color,
                backgroundColor: PaletteInfo[i].background_color,
                borderWidth: 3,
                fill: true,
              }
            },
          },
          options: {
            # https://misc.0o0o.org/chartjs-doc-ja/general/responsive.html
            # responsive: true,
            # maintainAspectRatio: true,
            # elements: {
            #   line: {
            #     tension: 0, # ベジェ曲線無効
            #   },
            # },
            # animation: {
            #   duration: 0, # 一般的なアニメーションの時間
            # },
          },
        },
      }
    end

    let :latest_open_limit do
      if v = params[:latest_open_index].presence
        [v.to_i.abs, 10].min.next
      end
    end

    let :exclude_column_names do
      ["meta_info", "csa_seq"]
    end

    concerning :IndexCustomMethods do
      included do
        let :current_placeholder do
          "ウォーズIDまたは対局URLを入力してください"
        end

        let :pure_current_scope do
          s = current_model.all

          s = s.includes(win_user: nil, memberships: [:user, :grade, :attack_tags, :defense_tags])

          if current_swars_user
            s = s.joins(memberships: :user).merge(Membership.where(user: current_swars_user))
          end

          if current_tags
            s = s.tagged_with(current_tags)
          end

          # "muser:username mtag:角換わり" で絞り込むと memberships の user が username かつ「角換わり」で絞れる
          # tag:username だと対戦相手が「角換わり」したのも出てきてしまう
          if current_mtags
            m = Membership.all
            if current_musers
              m = m.where(user: User.where(user_key: current_musers))
            end
            m = m.tagged_with(current_mtags)
            s = s.merge(m)
          end

          if current_ids
            s = s.where(id: current_ids)
          end

          if v = current_query_hash[:turn_max_gteq]
            s = s.where(Battle.arel_table[:turn_max].gteq(v))
          end

          if v = current_query_hash[:turn_max_lt]
            s = s.where(Battle.arel_table[:turn_max].lt(v))
          end

          # # 平手以外
          # if params[:handicap]
          #   s = s.tagged_with("平手", exclude: true)
          # end
          # s = s.order(battled_at: :desc)

          s
        end

        let :default_sort_column do
          "battled_at"
        end

        let :current_ransack do
          if current_query
            # current_model.ransack(title_or_description_cont: current_query)
          end
        end

        let :table_columns_hash do
          [
            { key: :id,               label: "ID",   visible: false,          },
            { key: :attack_tag_list,  label: "戦型", visible: !mobile_agent?, },
            { key: :defense_tag_list, label: "囲い", visible: false,          },
            { key: :final_info,       label: "結果", visible: false,          },
            { key: :turn_max,         label: "手数", visible: false,          },
            { key: :rule_info,        label: "種類", visible: false,          },
            { key: :preset_info,      label: "手合", visible: teai_p,         },
            { key: :battled_at,       label: "日時", visible: !mobile_agent?, },
          ]
        end

        let :js_current_records do
          current_records.collect do |e|
            a = e.attributes

            a[:kifu_copy_params] = e.to_kifu_copy_params(view_context)
            a[:sp_sfen_get_path] = polymorphic_path([ns_prefix, e], format: "json")

            a[:title] = e.to_title
            a[:final_info] = { name: e.final_info.name, url: swars_tag_search_path(e.final_info.name), "class": e.final_info.has_text_color, }

            if false
              a["戦法"] = e.tag_list.collect { |e| link_to(e, swars_tag_search_path(e)) }.join(" ").html_safe
            else
              # a["戦型"] = versus_tag(tag_links(l_ship.attack_tag_list), tag_links(r_ship.attack_tag_list))
              # a["囲い"] = versus_tag(tag_links(l_ship.defense_tag_list), tag_links(r_ship.defense_tag_list))
            end

            a[:battled_at] = e.battled_at.to_s(:battle_time)
            a[:preset_info] = { name: e.preset_info.name, url: swars_tag_search_path(e.preset_info.name),  }
            a[:rule_info] = { name: e.rule_info.name,   url: swars_tag_search_path(e.rule_info.name),    }
            a[:show_path] = polymorphic_path([ns_prefix, e])
            a[:piyo_shogi_app_url] = piyo_shogi_app_url(full_url_for([e, format: "kif"]))
            a[:swars_real_battle_url] = swars_real_battle_url(current_record)
            a[:wars_tweet_body] = e.wars_tweet_body

            a[:memberships] = left_right_pairs(e).collect do |label, e|
              attrs = {
                label: label,
                player_info_url: url_for([:swars, :player_infos, user_key: e.user.user_key, only_path: true]),
                icon_html: e.icon_html,
                name_with_grade: e.name_with_grade,
                query_user_url: polymorphic_path(e.user, current_mode: current_mode),
              }
              [:attack, :defense].each do |key|
                attrs["#{key}_tag_list"] = e.send("#{key}_tags").pluck(:name).collect { |e| {name: e, url: swars_tag_search_path(e) } }
              end
              attrs
            end

            a
          end
        end

        let :teai_p do
          current_tags && (current_tags.include?("駒落ち") || current_tags.include?("指導対局"))
        end
      end
    end
  end
end
