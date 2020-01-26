# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報 (swars_battles as Swars::Battle)
#
# |-------------------+------------------+--------------+-------------+------+-------|
# | name              | desc             | type         | opts        | refs | index |
# |-------------------+------------------+--------------+-------------+------+-------|
# | id                | ID               | integer(8)   | NOT NULL PK |      |       |
# | key               | 対局ユニークキー | string(255)  | NOT NULL    |      | A!    |
# | battled_at        | 対局日時         | datetime     | NOT NULL    |      | E     |
# | rule_key          | ルール           | string(255)  | NOT NULL    |      | B     |
# | csa_seq           | 棋譜             | text(65535)  | NOT NULL    |      |       |
# | final_key         | 結末             | string(255)  | NOT NULL    |      | C     |
# | win_user_id       | 勝者             | integer(8)   |             |      | D     |
# | turn_max          | 手数             | integer(4)   | NOT NULL    |      | F     |
# | meta_info         | メタ情報         | text(65535)  | NOT NULL    |      |       |
# | last_accessd_at   | 最終アクセス日時 | datetime     | NOT NULL    |      |       |
# | access_logs_count | アクセス数       | integer(4)   | DEFAULT(0)  |      |       |
# | created_at        | 作成日時         | datetime     | NOT NULL    |      |       |
# | updated_at        | 更新日時         | datetime     | NOT NULL    |      |       |
# | preset_key        | 手合割           | string(255)  | NOT NULL    |      |       |
# | start_turn        | 開始局面         | integer(4)   |             |      |       |
# | critical_turn     | 開戦             | integer(4)   |             |      | G     |
# | saturn_key        | 公開範囲         | string(255)  | NOT NULL    |      | H     |
# | sfen_body         | SFEN形式棋譜     | string(8192) |             |      |       |
# | image_turn        | OGP画像の局面    | integer(4)   |             |      |       |
# |-------------------+------------------+--------------+-------------+------+-------|

module Swars
  class BattlesController < ApplicationController
    include ModulableCrud::All
    include BattleControllerBaseMethods
    include BattleControllerSharedMethods
    include ExternalAppMethods

    helper_method :current_swars_user
    helper_method :current_query_info

    cattr_accessor(:labels_type1) { ["対象", "相手"] }
    cattr_accessor(:labels_type2) { ["勝ち", "負け"] }

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
      # FIXME: BOTを許可する
      if bot_agent?
        return
      end

      # FIXME: 名前変更する
      if params[:stop_processing_because_it_is_too_heavy]
        return
      end

      external_app_action1
      if performed?
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

      external_app_action2
      if performed?
        return
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
          redirect_to [:swars, :battles, query: v], alert: "URLを変更したのでトップにリダイレクトしました。お手数ですが新しい棋譜を取り込むには再度検索してください"
          return
        end
      end

      super
    end

    def create
      import_process(flash)
      flash[:import_skip] = true
      redirect_to [:swars, :battles, query: current_swars_user]
    end

    rescue_from "Mechanize::ResponseCodeError" do |exception|
      message = "該当のユーザーが見つからないか混み合っています"
      flash.now[:danger] = %(<div class="has-text-weight-bold">#{message}</div><br/>#{exception.class.name}<br/>#{exception.message}<br/><br/>#{exception.backtrace.take(8).join("<br/>")}).html_safe
      render :index
    end

    def js_index_options
      options = super.merge({
          current_swars_user_key: current_swars_user_key,
          required_query_for_search: AppConfig[:required_query_for_search], # js側から一覧のレコードを出すときは必ず query が入っていないといけない
        })
      if AppConfig[:player_info_function]
        if current_swars_user_key
          options[:player_info_path] = url_for([:swars, :player_infos, user_key: current_swars_user_key, only_path: true])
        end
      end
      options
    end

    def import_enable?
      v = true
      v &&= current_swars_user_key
      v &&= params[:page].blank?
      v &&= !params[:import_skip]
      v &&= !flash[:import_skip]
      v &&= !flash[:external_app_setup]
      v
    end

    private

    def import_process(flash)
      if import_enable?
        before_count = 0
        if current_swars_user
          before_count = current_swars_user.battles.count
        end

        if params[:force]
          Battle.user_import(user_key: current_swars_user_key, page_max: import_page_max)
          success = true
        else
          # 連続クロール回避 (fetchでは Rails.cache.write が後処理のためダメ)
          success = Battle.sometimes_user_import(user_key: current_swars_user_key, page_max: import_page_max)
          if !success
            # development でここが通らない
            # development では memory_store なのでリロードが入ると Rails.cache.exist? がつねに false を返している……？
            flash[:warning] = "#{current_swars_user_key} さんの棋譜はさっき取得したばかりです"
          end
        end

        if success
          unlet(:current_swars_user)

          hit_count = 0
          if current_swars_user
            hit_count = current_swars_user.battles.count - before_count
            if hit_count.zero?
              # flash[:warning] = "#{current_swars_user_key} さんの新しい棋譜は見つかりませんでした"
            else
              flash[:info] = "#{hit_count}件、新しく見つかりました"
            end
            current_swars_user.search_logs.create!
          else
            flash[:warning] = "#{current_swars_user_key} さんは存在しないかも？"
          end

          if hit_count.nonzero?
            slack_message(key: "検索", body: "#{current_swars_user_key} #{hit_count}件")
          end
        end
      end
    end

    let :import_page_max do
      (params[:page_max].presence || 1).to_i
    end

    def access_log_create(record)
      if bot_agent?
        return
      end

      if request.format.html?
        record.access_logs.create!
      end
    end

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

    def left_right_pairs(record)
      fliped = false
      a = record.memberships.to_a
      if current_swars_user
        labels = labels_type1
        if a.last.user == current_swars_user
          fliped = true
        end
      else
        labels = labels_type2
        if record.win_user_id
          if a.last.judge_key == "win"
            fliped = true
          end
        end
      end
      if fliped
        a = a.reverse
      end
      [fliped, labels.zip(a)]
    end

    def slow_processing_error_redirect_url
      [:swars, :battles, query: current_query, stop_processing_because_it_is_too_heavy: 1]
    end

    def swars_tag_search_path(e)
      if AppConfig[:swars_tag_search_function]
        url_for([:swars, :battles, query: "tag:#{e}", only_path: true])
      end
    end

    let :current_swars_user do
      User.find_by(user_key: current_swars_user_key)
    end

    let :current_musers do
      query_hash.dig(:muser)
    end

    let :current_ms_tags do
      query_hash.dig(:ms_tag)
    end

    let :current_swars_user_key do
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

    def js_show_options
      super.merge({
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
        })
    end

    let :exclude_column_names do
      ["meta_info", "csa_seq"]
    end

    concerning :IndexCustomMethods do
      let :current_placeholder do
        "ウォーズIDを入力してください"
      end

      def current_scope
        @current_scope ||= -> {
          s = super
          # s = s.includes(win_user: nil, memberships: [:user, :grade, :attack_tags, :defense_tags])
          s = s.includes(win_user: nil, memberships: {:user => nil, :grade => nil, taggings: :tag})

          if current_swars_user
            s = s.joins(memberships: :user).merge(Membership.where(user: current_swars_user))
          end

          # "muser:username ms_tag:角換わり" で絞り込むと memberships の user が username かつ「角換わり」で絞れる
          # tag:username だと相手が「角換わり」したのも出てきてしまう
          if current_ms_tags
            m = Membership.all
            if current_musers
              m = m.where(user: User.where(user_key: current_musers))
            end
            m = m.tagged_with(current_ms_tags)
            s = s.merge(m)
          end

          s
        }.call
      end

      def current_index_scope
        @current_index_scope ||= -> {
          s = current_scope
          unless current_swars_user
            if AppConfig[:required_user_key_for_search]
              s = s.none
            end
          end
          s
        }.call
      end

      def default_sort_column
        "battled_at"
      end

      def ransack_params
      end

      let :table_column_list do
        list = []
        unless Rails.env.production?
          list += [
            { key: :id,             label: "ID",   visible: true, },
          ]
        end
        list += [
          { key: :attack_tag_list,  label: "戦型", visible: true,  },
          { key: :defense_tag_list, label: "囲い", visible: false, },
          { key: :final_info,       label: "結果", visible: false, },
          { key: :turn_max,         label: "手数", visible: false, },
          { key: :critical_turn,    label: "開戦", visible: false, },
          # { key: :grade_diff,     label: "力差", visible: false, },
          { key: :rule_info,        label: "種類", visible: false, },
          { key: :preset_info,      label: "手合", visible: false, },
          { key: :battled_at,       label: "日時", visible: true,  },
        ]
        list
      end

      def js_record_for(e)
        a = super

        a[:final_info] = { name: e.final_info.name, url: swars_tag_search_path(e.final_info.name), "class": e.final_info.has_text_color, }
        a[:preset_info] = { name: e.preset_info.name, url: swars_tag_search_path(e.preset_info.name),  }
        a[:rule_info] = { name: e.rule_info.name,   url: swars_tag_search_path(e.rule_info.name),    }
        a[:swars_real_battle_url] = swars_real_battle_url(e)

        if AppConfig[:swars_side_tweet_copy_function]
          a[:wars_tweet_body] = e.wars_tweet_body
        end

        fliped, pairs = left_right_pairs(e)
        a[:memberships] = pairs.collect do |label, e|
          attrs = {
            label: label,
            icon_html: e.icon_html,
            name_with_grade: e.name_with_grade,
            query_user_url: polymorphic_path(e.user),
            swars_home_url: e.user.swars_home_url,
            google_search_url: google_search_url(e.user.user_key),
            twitter_search_url: twitter_search_url(e.user.user_key),
            location: { hexagon_mark: e.location.hexagon_mark },
            # position: e.position,
          }

          if AppConfig[:player_info_function]
            attrs[:player_info_path] = url_for([:swars, :player_infos, user_key: e.user.user_key, only_path: true])
          end

          [:attack, :defense].each do |key|
            # attrs["#{key}_tag_list"] = e.send("#{key}_tags").pluck(:name).collect do |e|
            #   { name: e, url: swars_tag_search_path(e) }
            # end

            attrs["#{key}_tag_list"] = e.tag_names_for(key).collect { |name|
              { name: name, url: swars_tag_search_path(name) }
            }

            # attrs["#{key}_tag_list"] = e.send("#{key}_tags").pluck(:name).collect do |e|
            #   { name: e, url: swars_tag_search_path(e) }
            # end
          end
          attrs
        end

        a[:fliped] = fliped

        a
      end
    end

    concerning :EditCustomMethods do
      def js_edit_options
        super.merge({
            run_mode: "view_mode",
          })
      end
    end
  end
end
