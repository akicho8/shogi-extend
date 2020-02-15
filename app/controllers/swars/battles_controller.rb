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
    include ExternalAppMod
    include ZipDlMod
    include RememberSwarsUserKeysMod

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

      kento_json_render
      if performed?
        return
      end

      external_app_setup
      if performed?
        return
      end

      if request.format.json?
        render json: js_current_records.to_json # 【重要】 明示的に to_json することで ActiveModelSerializer での変換の試みを回避する
        return
      end

      # 検索窓に将棋ウォーズへ棋譜URLが指定されたとき詳細に飛ばす
      if false
        if primary_key
          redirect_to [:swars, :battle, id: primary_key]
          return
        end
      end

      import_process2(flash)

      external_app_run
      if performed?
        return
      end

      zip_dl_perform
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
      import_process(flash)     # これはなに……？？？
      flash[:import_skip] = true
      redirect_to [:swars, :battles, query: current_swars_user]
    end

    rescue_from "Mechanize::ResponseCodeError" do |exception|
      message = "該当のデータが見つからないか混み合っています"
      flash.now[:warning] = message
      if Rails.env.development?
        flash.now[:danger] = %(<div class="has-text-weight-bold">#{message}</div><br/>#{exception.class.name}<br/>#{exception.message}<br/><br/>#{exception.backtrace.take(8).join("<br/>")}).html_safe
      end
      render :index
    end

    def js_index_options
      options = super.merge({
          current_swars_user_key: current_swars_user_key,
          required_query_for_search: AppConfig[:required_query_for_search], # js側から一覧のレコードを出すときは必ず query が入っていないといけない
          remember_swars_user_keys: remember_swars_user_keys,
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

    # 検索窓に将棋ウォーズへ棋譜URLが指定されたときの対局キー
    let :primary_key do
      if query = params[:query].presence
        Battle.battle_key_extract(query)
      end
    end

    def import_process2(flash)
      # 検索窓に将棋ウォーズへ棋譜URLが指定されたとき
      if primary_key
        # 一覧に表示したいので取得
        current_model.single_battle_import(key: primary_key)
      else
        import_process(flash.now)
      end
    end

    def import_process(flash)
      if import_enable?
        remember_swars_user_keys_update

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
            # ここを有効にするには rails dev:cache してキャッシュを有効にすること
            unless Rails.env.production?
              flash[:warning] = "#{current_swars_user_key} さんの棋譜はさっき取得したばかりです"
            end
          end
        end

        if success
          unlet(:current_swars_user)

          hit_count = 0
          if current_swars_user
            hit_count = current_swars_user.battles.count - before_count
            if hit_count.zero?
              unless Rails.env.production?
                flash[:warning] = "#{current_swars_user_key} さんの新しい棋譜は見つかりませんでした"
              end
            else
              flash[:toast_info] = "#{hit_count}件、新しく見つかりました"
            end
            current_swars_user.search_logs.create!
          else
            flash[:warning] = "#{current_swars_user_key} さんは存在しないかも？"
          end

          if hit_count.nonzero?
            unless Rails.env.production?
              slack_message(key: "検索", body: "#{current_swars_user_key} #{hit_count}件")
            end
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

    # 対局URLが指定されているときはそれを優先するので current_swars_user_key を拾ってはいけない
    # 拾うと次の文字列の先頭をウォーズIDと解釈してしまう
    # "将棋ウォーズ棋譜(maosuki:5級 vs kazookun:2級) #shogiwars #棋神解析 https://kif-pona.heroz.jp/games/maosuki-kazookun-20200204_211329?tw=1"
    let :current_swars_user_key do
      unless primary_key
        current_swars_user_key_from_url || current_query_info.values.first
      end
    end

    # https://shogiwars.heroz.jp/users/history/foo?gtype=&locale=ja -> foo
    # https://shogiwars.heroz.jp/users/foo                          -> foo
    def current_swars_user_key_from_url
      if url = current_query_info.urls.first
        if url = URI::Parser.new.extract(url).first
          uri = URI(url)
          if uri.path
            if md = uri.path.match(%r{/users/history/(.*)|/users/(.*)})
              s = md.captures.compact.first
              ERB::Util.html_escape(s)
            end
          end
        end
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
        "ウォーズIDを入力"
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
          if primary_key
            s = s.where(key: primary_key)
          else
            if current_swars_user
            else
              if AppConfig[:required_user_key_for_search]
                s = s.none
              end
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
          list << { key: :id,             label: "ID",   visible: true, }
        end
        list << { key: :attack_tag_list,  label: "戦型", visible: true,  }
        list << { key: :defense_tag_list, label: "囲い", visible: false,  }
        list << { key: :final_info,       label: "結果", visible: false, }
        list << { key: :turn_max,         label: "手数", visible: false, }
        if AppConfig[:columns_detail_show]
          list << { key: :critical_turn,    label: "開戦", visible: false, }
          list << { key: :grade_diff,       label: "力差", visible: false, }
        end
        list << { key: :rule_info,        label: "種類", visible: false, }
        list << { key: :preset_info,      label: "手合", visible: false, }
        list << { key: :battled_at,       label: "日時", visible: true,  }
        list
      end

      def js_record_for(e)
        a = super

        a[:final_info] = { name: e.final_info.name, url: swars_tag_search_path(e.final_info.name), "class": e.final_info.has_text_color, }
        a[:preset_info] = { name: e.preset_info.name, url: swars_tag_search_path(e.preset_info.name),  }
        a[:rule_info] = { name: e.rule_info.name,   url: swars_tag_search_path(e.rule_info.name),    }
        a[:official_swars_battle_url] = official_swars_battle_url(e)

        if AppConfig[:swars_side_tweet_copy_function]
          a[:swars_tweet_text] = e.swars_tweet_text
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
              { name: name, url: url_for([:tactic_note, id: name]) }
            }

            # attrs["#{key}_tag_list"] = e.send("#{key}_tags").pluck(:name).collect do |e|
            #   { name: e, url: swars_tag_search_path(e) }
            # end
          end
          attrs
        end

        a[:fliped] = fliped

        if AppConfig[:columns_detail_show]
          # 左側にいるひとから見た右側の人の力差
          a[:grade_diff] = pairs.first.last.grade_diff
        end

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
