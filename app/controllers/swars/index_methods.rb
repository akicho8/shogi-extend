module Swars
  concern :IndexMethods do
    included do
      rescue_from "Swars::Agent::OfficialFormatChanged" do |exception|
        render json: { status: :error, type: :danger, message: exception.message }
      end
    end

    def index
      @xnotice = Xnotice.new

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
      #     redirect_to UrlProxy.url_for(path)
      #     return
      #   end
      #
      #   if params[:latest_open_index] && current_swars_user_key
      #     external_app_key = params[:external_app_key] || :piyo_shogi
      #     path = "/swars/users/#{current_swars_user_key}/direct-open/#{external_app_key}"
      #     redirect_to UrlProxy.url_for(path)
      #     return
      #   end
      #
      #   path = ["/swars/search", query].compact.join("?")
      #   redirect_to UrlProxy.url_for(path)
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

    # http://localhost:3000/w.json?query=Yamada_Taro&format_type=user
    def swars_users_key_json_render
      if request.format.json? && format_type == "user"
        unless current_swars_user
          render json: {}, status: :not_found
          return
        end
        if params[:try_fetch] == "true"
          import_process2
        end
        if Rails.env.test?
          slack_notify(subject: "新プ情報", body: current_swars_user.key)
        end
        render json: current_swars_user.user_info(params.to_unsafe_h.to_options).to_hash.as_json
        return
      end
    end

    # インポートする条件 (重要)
    #
    #   1. ウォーズIDが指定されている (Userレコードの有無は関係なし)
    #   2. ページング中ではないこと
    #   3. 人間であること
    #
    def import_enable?
      current_swars_user_key && params[:page].blank? && !request.from_crawler?
    end

    def js_index_options
      {
        :xnotice                => @xnotice,
        :import_enable_p        => import_enable?,
        :current_swars_user_key => current_swars_user ? current_swars_user.key : nil,
        :viewpoint              => current_viewpoint,
      }.merge(super).merge({
          :remember_swars_user_keys  => remember_swars_user_keys,
        })
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
      @xnotice = Xnotice.new

      if import_enable?
        remember_swars_user_keys_update

        errors = []
        import_params = {
          :user_key           => current_swars_user_key,
          :page_max           => import_page_max,
          :force              => params[:force],
          :error_capture_fake => params[:error_capture_fake],
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
          @xnotice.add("さっき取得したばかりです", type: "is-warning", development_only: true)
        end

        if success
          unlet(:current_swars_user)

          hit_count = 0
          if current_swars_user
            hit_count = current_swars_user.battles.count - before_count
            if hit_count.zero?
              @xnotice.add("新しい棋譜は見つかりませんでした", type: "is-dark", development_only: true)
            else
              @xnotice.add("#{hit_count}件、新しく見つかりました", type: "is-info")
            end
            current_swars_user.search_logs.create!
          else
            @xnotice.add("#{current_swars_user_key}さんは存在しません", type: "is-warning")
          end

          if hit_count.nonzero?
            if Rails.env.production? || Rails.env.staging?
            else
              slack_notify(subject: "検索", body: "#{current_swars_user_key} #{hit_count}件")
            end
          end

          # 確認方法
          # http://localhost:3000/w?query=devuser1&error_capture_fake=true&force=true
          if errors.present?
            errors.each do |e|
              body = [
                e[:error].message.strip,
                "https://shogiwars.heroz.jp/games/#{e[:key]}?locale=ja",
              ].join("\n")
              SystemMailer.notify(fixed: true, subject: "【ウォーズ棋譜不整合】#{e[:error].message.lines.first.strip}", body: body).deliver_later
            end
            message = errors.collect { |e|
              [
                e[:error].message.strip,
                "https://shogiwars.heroz.jp/games/#{e[:key]}?locale=ja",
              ].collect { |e| "#{e}\n" }.join
            }.join("\n").gsub(/\R/, "<br>")
            @xnotice.add(message, type: "is-danger", method: :dialog, title: "棋譜の不整合")
          end
        end
      end
    end

    let :import_page_max do
      (params[:page_max].presence || 1).to_i
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

    # http://localhost:3000/w.json?query=https://shogiwars.heroz.jp/games/devuser3-Yamada_Taro-20200101_123403
    # http://localhost:4000/swars/search?query=https://shogiwars.heroz.jp/games/devuser3-Yamada_Taro-20200101_123403
    # "将棋ウォーズ棋譜(maosuki:5級 vs kazookun:2級) #shogiwars #棋神解析 https://shogiwars.heroz.jp/games/Kato_Hifumi-SiroChannel-20200927_180900?tw=1"
    let :current_swars_user_key do
      v = nil
      v ||= extract_type1
      v ||= extract_type2
      v ||= extract_type3

      # # url = query_info.urls.first
      # # v ||= nil
      # # v ||= Battle.user_key_extract_from_battle_url(url) # https://shogiwars.heroz.jp/games/foo-bar-20200204_211329" --> foo
      # # v ||= extract_type1              # https://shogiwars.heroz.jp/users/foo                      --> foo
      #
      # unless primary_record_key
      #   extract_type1 || query_info.values.first
      # end
    end

    # https://shogiwars.heroz.jp/users/history/foo?gtype=&locale=ja -> foo
    # https://shogiwars.heroz.jp/users/foo                          -> foo
    def extract_type1
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

    # https://shogiwars.heroz.jp/games/foo-bar-20200204_211329" --> foo
    def extract_type2
      if url = query_info.urls.first
        Battle.user_key_extract_from_battle_url(url)
      end
    end

    # "foo" --> foo
    def extract_type3
      query_info.values.first
    end

    def exclude_column_names
      ["meta_info", "csa_seq"]
    end

    # FIXME: モデルに移動
    def current_scope
      @current_scope ||= -> {
        s = current_model.all

        if v = query_info.lookup(:ids)
          s = s.where(id: v)
        end

        if v = primary_record_key # バトルが指定されている
          s = s.where(key: v)
        end

        if v = query_info.lookup_one(:rule) || query_info.lookup_one(:"種類")
          s = s.rule_eq(v)
        end

        if e = query_info.lookup_op(:critical_turn) || query_info.lookup_op(:"開戦")
          s = s.where(current_model.arel_table[:critical_turn].public_send(e[:operator], e[:value]))
        end

        if e = query_info.lookup_op(:outbreak_turn) || query_info.lookup_op(:"中盤")
          s = s.where(current_model.arel_table[:outbreak_turn].public_send(e[:operator], e[:value]))
        end

        if e = query_info.lookup_op(:turn_max) || query_info.lookup_op(:"手数")
          s = s.where(current_model.arel_table[:turn_max].public_send(e[:operator], e[:value]))
        end

        if v = query_info.lookup_one(:"final") || query_info.lookup_one(:"最後") || query_info.lookup_one(:"結末")
          s = s.where(current_model.arel_table[:final_key].eq(FinalInfo.fetch(v).key))
        end

        if current_swars_user
          selected = false
          if t = query_info.lookup_one(:"date") # 日付
            t = t.to_time.midnight

            m = my_sampled_memberships
            s = s.where(id: m.pluck(:battle_id))

            s = s.where(battled_at: t...t.tomorrow)
            selected = true
          end
          if v = query_info.lookup_one(:"judge") || query_info.lookup_one(:"勝敗")
            m = my_sampled_memberships
            p JudgeInfo.fetch(v)
            m = m.where(judge_key: JudgeInfo.fetch(v).key)
            s = s.where(id: m.pluck(:battle_id))
            selected = true
          end
          if v = query_info.lookup(:"tag") # 自分 戦法(AND)
            m = my_sampled_memberships
            m = m.tagged_with(v)
            s = s.where(id: m.pluck(:battle_id))
            selected = true
          end
          if v = query_info.lookup(:"or-tag") # 自分 戦法(OR)
            m = my_sampled_memberships
            m = m.tagged_with(v, any: true)
            s = s.where(id: m.pluck(:battle_id))
            selected = true
          end
          if v = query_info.lookup(:"vs-tag") # 相手 対抗
            m = sampled_memberships(current_swars_user.op_memberships)
            m = m.tagged_with(v)
            s = s.where(id: m.pluck(:battle_id))
            selected = true
          end
          if v = query_info.lookup(:"vs-or-tag") # 相手 対抗
            m = sampled_memberships(current_swars_user.op_memberships)
            m = m.tagged_with(v, any: true)
            s = s.where(id: m.pluck(:battle_id))
            selected = true
          end
          if v = query_info.lookup_one(:"vs-grade") # 段級
            grade = Grade.fetch(v)
            m = sampled_memberships(current_swars_user.op_memberships)
            m = m.where(grade: grade)
            s = s.where(id: m.pluck(:battle_id))
            selected = true
          end
          if e = query_info.lookup_op(:"vs-grade-diff") || query_info.lookup_op(:"力差")
            m = my_sampled_memberships
            m = m.where(Membership.arel_table[:grade_diff].public_send(e[:operator], e[:value]))
            s = s.where(id: m.pluck(:battle_id))
            selected = true
          end
          if v = query_info.lookup(:"vs") # 相手
            users = Swars::User.where(user_key: v)
            m = current_swars_user.op_memberships.where(user: users)
            s = s.where(id: m.pluck(:battle_id))
            selected = true
          end
          unless selected
            s = s.joins(:memberships).merge(Membership.where(user_id: current_swars_user.id))
          end
        end

        s = s.includes(win_user: nil, memberships: {user: nil, grade: nil, taggings: :tag})

        s
      }.call
    end

    def my_sampled_memberships
      @my_sampled_memberships ||= current_swars_user.memberships
    end

    def op_sampled_memberships
      @op_sampled_memberships ||= current_swars_user.op_memberships
    end

    def sampled_memberships(m)
      m = m.joins(:battle)

      # FIXME: プレイヤー情報と条件を合わせるためハードコーディング
      # m = m.merge(Swars::Battle.win_lose_only) # 勝敗が必ずあるもの
      m = m.merge(Swars::Battle.newest_order)  # 直近のものから取得

      # FIXME: ↓これいらなくね？
      if true
        if v = query_info.lookup_one(:"sample")
          m = m.limit(v)          # N件抽出
        else
          # 指定しなくてもすでにuserで絞っているので爆発しない
        end
      end

      Swars::Membership.where(id: m.ids)
    end

    def current_index_scope
      @current_index_scope ||= -> {
        s = current_scope
        unless primary_key_like?
          s = s.none
        end
        s
      }.call
    end

    # primary_record_key に対応するレコード
    let :primary_record do
      if primary_record_key
        Swars::Battle.find_by(key: primary_record_key)
      end
    end

    def sort_column_default
      "battled_at"
    end

    private

    def primary_key_like?
      if Rails.env.development? && params[:all]
        return true
      end

      current_swars_user || primary_record_key || query_info.lookup(:ids)
    end
  end
end
