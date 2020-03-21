module Swars
  concern :IndexMod do
    included do
      helper_method :current_swars_user
      helper_method :current_query_info
      helper_method :twitter_card_options

      rescue_from "Mechanize::ResponseCodeError" do |exception|
        message = "該当のデータが見つからないか混み合っています"
        flash.now[:warning] = message
        if Rails.env.development?
          flash.now[:danger] = %(<div class="has-text-weight-bold">#{message}</div><br/>#{exception.class.name}<br/>#{exception.message}<br/><br/>#{exception.backtrace.take(8).join("<br/>")}).html_safe
        end
        render :index
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

      if request.format.json? && format_type == "user"
        if current_swars_user
          render json: current_swars_user.summary_info2.to_hash.as_json
          return
        end
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
        if primary_record_key
          redirect_to [:swars, :battle, id: primary_record_key]
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

    def js_index_options
      options = super.merge({
          current_swars_user_key: current_swars_user_key,
          required_query_for_search: AppConfig[:required_query_for_search], # js側から一覧のレコードを出すときは必ず query が入っていないといけない
          remember_swars_user_keys: remember_swars_user_keys,
          import_enable_p: import_enable?,
        })
      if AppConfig[:player_info_function]
        if current_swars_user_key
          options[:player_info_path] = url_for([:swars, :player_infos, user_key: current_swars_user_key, only_path: true])
        end
      end
      options
    end

    let :twitter_card_options do
      case
      when v = modal_record
        # http://localhost:3000/w?modal_id=1
        v.to_twitter_card_params(params)
      when v = primary_record
        # http://localhost:3000/w?query=https://kif-pona.heroz.jp/games/maosuki-kazookun-20200204_211329?tw=1
        v.to_twitter_card_params(params)
      when current_swars_user
        # http://localhost:3000/w?query=itoshinTV
        {
          :card        => "summary",
          :title       => "#{current_swars_user.name_with_grade}の棋譜リスト",
          :description => "#{current_swars_user.battles.count}件",
        }
      else
        # http://localhost:3000/w
        {
          :title       => "将棋ウォーズ棋譜検索",
          :description => "ぴよ将棋やKENTOと連携して開けます。またクリップボード経由で棋譜を外部の将棋アプリに渡すような使い方ができます",
          :image       => "swars_battles_index.png",
        }
      end
    end

    # 検索窓に将棋ウォーズへ棋譜URLが指定されたときの対局キー
    let :primary_record_key do
      if query = params[:query].presence
        Battle.battle_key_extract(query)
      end
    end

    def import_process2(flash)
      # 検索窓に将棋ウォーズへ棋譜URLが指定されたとき
      if primary_record_key
        # 一覧に表示したいので取得
        current_model.single_battle_import(key: primary_record_key)
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
            if Rails.env.production? || Rails.env.staging?
            else
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
              if Rails.env.production? || Rails.env.staging?
              else
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
            if Rails.env.production? || Rails.env.staging?
            else
              slack_message(key: "検索", body: "#{current_swars_user_key} #{hit_count}件")
            end
          end
        end
      end
    end

    let :import_page_max do
      (params[:page_max].presence || 1).to_i
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
      unless primary_record_key
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

    def exclude_column_names
      ["meta_info", "csa_seq"]
    end

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
        case
        when primary_record_key
          s = s.where(key: primary_record_key)
        when modal_record
          s = s.where(key: modal_record.to_param)
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

    # primary_record_key に対応するレコード
    let :primary_record do
      if primary_record_key
        current_scope.find_by(key: primary_record_key)
      end
    end

    def default_sort_column
      "battled_at"
    end

    def ransack_params
    end

    let :table_column_list do
      list = []
      if Rails.env.production? || Rails.env.staging?
      else
        list << { key: :id,             label: "ID",   visible: true, }
      end
      list << { key: :attack_tag_list,  label: "戦型", visible: true,  }
      list << { key: :defense_tag_list, label: "囲い", visible: false,  }
      list << { key: :final_info,       label: "結果", visible: false, }
      list << { key: :turn_max,         label: "手数", visible: false, }
      if AppConfig[:columns_detail_show]
        list << { key: :critical_turn,    label: "開戦", visible: false, }
        list << { key: :outbreak_turn,    label: "仕掛", visible: false, }
        list << { key: :grade_diff,       label: "力差", visible: false, }
      end
      list << { key: :rule_info,        label: "種類", visible: false, }
      list << { key: :preset_info,      label: "手合", visible: false, }
      list << { key: :battled_at,       label: "日時", visible: true,  }
      list
    end
  end
end
