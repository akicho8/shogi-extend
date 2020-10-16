module Swars
  concern :IndexMod do
    included do
      helper_method :current_swars_user
      helper_method :query_info
      helper_method :twitter_card_options

      rescue_from "Swars::Agent::OfficialFormatChanged" do |exception|
        render json: { status: :error, type: :danger, message: exception.message }
      end
    end

    def index
      @notice_collector = NoticeCollector.new

      [
        :redirect_if_old_path,
        :kento_json_render,
        :swars_users_key_json_render,
        :zip_dl_perform,
        :default_json_render,
      ].each do |e|
        send(e)
        if performed?
          return
        end
      end
    end

    # 新しいURLにリダイレクト
    def redirect_if_old_path
      # routes.rb に移動
      #
      # if params[:format].blank? || request.format.html?
      #   query = params.permit!.to_h.except(:controller, :action, :format, :modal_id).to_query.presence
      #
      #   # http://localhost:3000/w?flip=false&modal_id=devuser1-Yamada_Taro-20200101_123401&turn=34
      #   if modal_id = params[:modal_id].presence
      #     path = ["/swars/battles/#{modal_id}", query].compact.join("?")
      #     redirect_to UrlProxy.wrap(path)
      #     return
      #   end
      #
      #   if params[:latest_open_index] && current_swars_user_key
      #     external_app_key = params[:external_app_key] || :piyo_shogi
      #     path = "/swars/users/#{current_swars_user_key}/direct-open/#{external_app_key}"
      #     redirect_to UrlProxy.wrap(path)
      #     return
      #   end
      #
      #   path = ["/swars/search", query].compact.join("?")
      #   redirect_to UrlProxy.wrap(path)
      #   return
      # end
    end

    def default_json_render
      if request.format.json?
        import_process2
        render json: js_index_options.as_json
        return
      end
    end

    def swars_users_key_json_render
      if request.format.json? && format_type == "user"
        unless current_swars_user
          render json: { notice_collector: NoticeCollector.single(:danger, "#{current_swars_user_key}さんが見つかりません", method: "dialog") }
          return
        end

        if params[:try_fetch] == "true"
          import_process2
        end
        if Rails.env.test?
          slack_message(key: "新プ情報", body: current_swars_user.key)
        end
        render json: { user_info: current_swars_user.user_info(params.to_unsafe_h.to_options).to_hash.as_json }
        return
      end
    end

    def import_enable?
      current_swars_user_key && params[:page].blank?
    end

    def js_index_options
      {
        :notice_collector       => @notice_collector,
        :import_enable_p        => import_enable?,
        :current_swars_user_key => current_swars_user_key,
      }.merge(super).merge({
          :remember_swars_user_keys  => remember_swars_user_keys,
          :per_page_list             => [
            *(Rails.env.development? ? [0, 1] : []),
            Kaminari.config.default_per_page,
            *AppConfig[:per_page_list],
            Kaminari.config.max_per_page,
          ],
        })
    end

    let :twitter_card_options do
      case
      when v = primary_record
        # http://localhost:3000/w?query=https://kif-pona.heroz.jp/games/maosuki-kazookun-20200204_211329?tw=1
        v.to_twitter_card_params(params)
      when current_swars_user && params[:user_info_show] == "true"
        # http://localhost:3000/w?query=itoshinTV&user_info_show=true
        {
          :card        => "summary",
          :title       => "#{current_swars_user.name_with_grade}のプレイヤー情報",
          # :description => "#{current_swars_user.battles.count}件",
        }
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
          :image       => nil,
        }
      end
    end

    # 検索窓に将棋ウォーズへ棋譜URLが指定されたときの対局キー
    let :primary_record_key do
      if query = params[:query].presence
        Battle.battle_key_extract(query)
      end
    end

    def import_process2
      if primary_record_key
        Swars::Battle.single_battle_import(key: primary_record_key)
      else
        import_process
      end
    end

    def import_process
      @notice_collector = NoticeCollector.new

      if import_enable?
        remember_swars_user_keys_update

        errors = []
        import_params = {
          :user_key           => current_swars_user_key,
          :page_max           => import_page_max,
          :force              => params[:force],
          :error_capture_test => params[:error_capture_test],
          :error_capture      => -> error { errors << error },
        }

        if Rails.env.development? || Rails.env.test?
          if params[:destroy_all]
            if current_swars_user
              Battle.where(id: current_swars_user.battle_ids).destroy_all # user.battles.destroy_all だと memberships の片方が残る
            end
          end
        end

        before_count = 0
        if current_swars_user
          before_count = current_swars_user.battles.count
        end

        # 連続クロール回避 (fetchでは Rails.cache.write が後処理のためダメ)
        success = Battle.throttle_user_import(import_params)
        if !success
          # ここを有効にするには rails dev:cache してキャッシュを有効にすること
          @notice_collector.add(:warning, "さっき取得したばかりです", development_only: true)
        end

        if success
          unlet(:current_swars_user)

          hit_count = 0
          if current_swars_user
            hit_count = current_swars_user.battles.count - before_count
            if hit_count.zero?
              @notice_collector.add(:dark, "新しい棋譜は見つかりませんでした", development_only: true)
            else
              @notice_collector.add(:info, "#{hit_count}件、新しく見つかりました")
            end
            current_swars_user.search_logs.create!
          else
            @notice_collector.add(:warning, "#{current_swars_user_key}さんは存在しません。アルファベットの大文字小文字を見直してください")
          end

          if hit_count.nonzero?
            if Rails.env.production? || Rails.env.staging?
            else
              slack_message(key: "検索", body: "#{current_swars_user_key} #{hit_count}件")
            end
          end

          # 確認方法
          # http://localhost:3000/w?query=devuser1&error_capture_test=true&force=true
          if errors.present?
            errors.each do |e|
              body = [
                e[:error].message.strip,
                "https://shogiwars.heroz.jp/games/#{e[:key]}?locale=ja",
              ].join("\n")
              ApplicationMailer.developper_notice(subject: "【ウォーズ棋譜不整合】#{e[:error].message.lines.first.strip}", body: body).deliver_later
            end
            message = errors.collect { |e|
              [
                e[:error].message.strip,
                "https://shogiwars.heroz.jp/games/#{e[:key]}?locale=ja",
              ].collect { |e| "#{e}\n" }.join
            }.join("\n").gsub(/\R/, "<br>")
            @notice_collector.add(:danger, message, method: "dialog", title: "棋譜の不整合")
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
      query_info.lookup(:muser)
    end

    let :current_ms_tags do
      query_info.lookup(:ms_tag)
    end

    # 対局URLが指定されているときはそれを優先するので current_swars_user_key を拾ってはいけない
    # 拾うと次の文字列の先頭をウォーズIDと解釈してしまう
    # "将棋ウォーズ棋譜(maosuki:5級 vs kazookun:2級) #shogiwars #棋神解析 https://kif-pona.heroz.jp/games/maosuki-kazookun-20200204_211329?tw=1"
    let :current_swars_user_key do
      unless primary_record_key
        current_swars_user_key_from_url || query_info.values.first
      end
    end

    # https://shogiwars.heroz.jp/users/history/foo?gtype=&locale=ja -> foo
    # https://shogiwars.heroz.jp/users/foo                          -> foo
    def current_swars_user_key_from_url
      if url = query_info.urls.first
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

    def current_scope
      @current_scope ||= -> {
        s = Swars::Battle.all

        if v = query_info.lookup(:ids)
          s = s.where(id: v)
        end

        if current_swars_user
          filtered = false
          if t = query_info.lookup_one(:"date") # 日付
            t = t.to_time.midnight

            m = sampled_memberships(current_swars_user.memberships)
            s = s.where(id: m.pluck(:battle_id))

            s = s.where(battled_at: t...t.tomorrow)
            filtered = true
          end
          if v = query_info.lookup_one(:"judge") # 勝ち負け
            m = sampled_memberships(current_swars_user.memberships)
            m = m.where(judge_key: v)
            s = s.where(id: m.pluck(:battle_id))
            filtered = true
          end
          if v = query_info.lookup_one(:"tag") # 戦法
            m = sampled_memberships(current_swars_user.memberships)
            m = m.tagged_with(v)
            s = s.where(id: m.pluck(:battle_id))
            filtered = true
          end
          if v = query_info.lookup_one(:"vs-tag") # 対抗
            m = sampled_memberships(current_swars_user.op_memberships)
            m = m.tagged_with(v)
            s = s.where(id: m.pluck(:battle_id))
            filtered = true
          end
          if v = query_info.lookup_one(:"vs-grade") # 段級
            grade = Grade.find_by!(key: v)
            m = sampled_memberships(current_swars_user.op_memberships)
            m = m.where(grade: grade)
            s = s.where(id: m.pluck(:battle_id))
            filtered = true
          end
          if v = query_info.lookup_one(:"vs") # 相手
            user = Swars::User.find_by(user_key: v)
            m = current_swars_user.op_memberships.where(user: user)
            s = s.where(id: m.pluck(:battle_id))
            filtered = true
          end
          unless filtered
            s = s.joins(:memberships).merge(Membership.where(user_id: current_swars_user.id))
          end
        end

        s.includes(win_user: nil, memberships: {user: nil, grade: nil, taggings: :tag})
      }.call
    end

    def sampled_memberships(m)
      m = m.joins(:battle)

      # FIXME: プレイヤー情報と条件を合わせるためハードコーディングされている
      m = m.merge(Swars::Battle.win_lose_only) # 勝敗が必ずあるもの
      m = m.merge(Swars::Battle.newest_order)  # 直近のものから取得

      if v = query_info.lookup_one(:"sample")
        m = m.limit(v)          # N件抽出
      else
        # 指定しなくてもすでにuserで絞っているので爆発しない
      end
      Swars::Membership.where(id: m.ids)   # 再スコープ
    end

    def current_index_scope
      @current_index_scope ||= -> {
        s = current_scope
        case
        when primary_record_key
          s = s.where(key: primary_record_key)
        else
          if current_swars_user
          else
            s = s.none
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

    def sort_column_default
      "battled_at"
    end

    def ransack_params
    end

    let :table_column_list do
      list = []
      if Rails.env.development? || Rails.env.test?
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
