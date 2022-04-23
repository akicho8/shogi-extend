module Swars
  concern :IndexMethods do
    included do
      before_action do
        @xnotice = Xnotice.new
      end

      # rescue_from "Swars::Agent::SwarsBattleNotFound" do |exception|
      #   @xnotice.add(exception.message, type: "is-danger", method: :dialog, title: exception.title)
      #   render json: js_index_options.as_json, status: 404
      # end

      # rescue_from "Swars::Agent::BaseError" do |exception|
      #   render json: { status: :error, type: :danger, message: exception.message }
      #   # else
      #   #   @xnotice.add(exception.message, type: "is-danger", method: :dialog, title: exception.title)
      #   #   render json: { :xnotice => @xnotice }.as_json
      #   # end
      # end

      # rescue_from "Swars::Agent::BaseError" do |exception|
      #   if false
      #     render json: { status: :error, type: :danger, message: exception.message }
      #   else
      #     @xnotice.add(exception.message, type: "is-danger", method: :dialog, title: exception.title)
      #     render json: { :xnotice => @xnotice }.as_json
      #   end
      # end
      #
      # rescue_from "Swars::Agent::SwarsBattleNotFound" do |exception|
      #   @xnotice.add(exception.message, type: "is-danger", method: :dialog, title: exception.title)
      #   render json: js_index_options.as_json, status: 404
      # end

      rescue_from "Swars::Agent::BaseError" do |exception|
        # @xnotice.add(exception.message, type: "is-danger", method: :dialog, title: exception.title)
        # render json: { :xnotice => @xnotice }.as_json

        # @xnotice.add(exception.message, type: "is-danger", method: :dialog, title: exception.title)
        # render json: { status: :error, type: :danger, message: exception.message }, status: 500
        SlackAgent.notify_exception(exception)
        render json: { message: exception.message }, status: exception.status
        # render json: js_index_options.as_json, status: 404
      end

    end

    def index
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
        if Rails.env.development?
          SlackAgent.notify(subject: "プレイヤー情報", body: "参照 #{current_swars_user.key.inspect}")
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
    def primary_record_key
      @primary_record_key ||= yield_self do
        if query = params[:query].presence
          Battle.battle_key_extract(query)
        end
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
      if import_enable?
        remember_swars_user_keys_update

        errors = []
        import_params = {
          :user_key                => current_swars_user_key,
          :page_max                => import_page_max,
          :force                   => params[:force],
          :error_capture_fake      => params[:error_capture_fake],
          :error_capture           => -> error { errors << error },
          :SwarsFormatIncompatible => params[:SwarsFormatIncompatible],
          :SwarsConnectionFailed   => params[:SwarsConnectionFailed],
          :SwarsUserNotFound       => params[:SwarsUserNotFound],
          :SwarsBattleNotFound     => params[:SwarsBattleNotFound],
        }

        if Rails.env.development? || Rails.env.test?
          if params[:destroy_all]
            if current_swars_user
              Battle.where(id: current_swars_user.battle_ids).destroy_all # user.battles.destroy_all だと memberships の片方が残る
            end
          end
          if params[:swars_user_destroy_all]
            DbCop.foreign_key_checks_disable
            User.destroy_all
            Battle.destroy_all
            remove_instance_variable(:@current_swars_user)
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
          remove_instance_variable(:@current_swars_user)

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
            SlackAgent.notify(emoji: ":NOT_FOUND:", subject: "ウォーズID不明", body: current_swars_user_key.inspect)
            @xnotice.add("#{current_swars_user_key}さんは存在しません。大文字と小文字を間違えていませんか？", type: "is-warning")
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

    def import_page_max
      @import_page_max ||= (params[:page_max].presence || 1).to_i
    end

    def swars_tag_search_path(e)
      if AppConfig[:swars_tag_search_function]
        url_for([:swars, :battles, query: "tag:#{e}", only_path: true])
      end
    end

    def current_swars_user
      @current_swars_user ||= User.find_by(user_key: current_swars_user_key)
    end

    def current_musers
      @current_musers ||= query_info.lookup(:muser)
    end

    def current_ms_tags
      @current_ms_tags ||= query_info.lookup(:ms_tag)
    end

    # http://localhost:3000/w.json?query=https://shogiwars.heroz.jp/games/devuser3-Yamada_Taro-20200101_123403
    # http://localhost:4000/swars/search?query=https://shogiwars.heroz.jp/games/devuser3-Yamada_Taro-20200101_123403
    # "将棋ウォーズ棋譜(maosuki:5級 vs kazookun:2級) #shogiwars #棋神解析 https://shogiwars.heroz.jp/games/Kato_Hifumi-SiroChannel-20200927_180900?tw=1"
    def current_swars_user_key
      @current_swars_user_key ||= yield_self do
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

    def current_scope
      @current_scope ||= current_model.search(self)
    end

    def current_index_scope
      @current_index_scope ||= yield_self do
        s = current_scope
        unless primary_key_like?
          s = s.none
        end
        s
      end
    end

    # primary_record_key に対応するレコード
    def primary_record
      @primary_record ||= yield_self do
        if primary_record_key
          Swars::Battle.find_by(key: primary_record_key)
        end
      end
    end

    def sort_column_default
      "battled_at"
    end

    def sort_scope(s)
      if sort_column && sort_order
        table, column = sort_column.split(".", 2)
        if column
          if table == "membership"
            # Membership が対象の並び替え
            # column は grade_diff, location_key, judge_key のどれかになる
            if current_swars_user
              o = current_swars_user.memberships.order(column => sort_order)
              s = s.joins(:memberships).merge(o)
            end
          else
            raise ArgumentError, sort_column.inspect
          end
        else
          # Battle のカラムに対するとソート
          s = super(s)
        end
      end
      s
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
