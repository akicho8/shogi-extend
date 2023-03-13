module Swars
  concern :IndexMethods do
    def index
      [
        :case_kento_api,
        :case_player_info,
        :case_zip_download,
        :case_swars_search,
      ].each do |e|
        send(e)
        if performed?
          return
        end
      end
    end

    # http://localhost:3000/w.json?query=DevUser1&format_type=kento
    # https://www.shogi-extend.com/w.json?query=kinakom0chi&format_type=kento
    def case_kento_api
      if request.format.json?
        if params[:format_type] == "kento"
          if current_swars_user
            render json: KentoApiResponder.new({
                :scope         => current_index_scope,
                :user          => current_swars_user,
                :max           => params[:limit],
                :notify_params => {
                  :referer    => request.referer,
                  :user_agent => request.user_agent,
                },
              })
          end
        end
      end
    end

    # http://localhost:3000/w.json?user_key=YamadaTaro&query=%E6%8C%81%E3%81%A1%E6%99%82%E9%96%93:10%E5%88%86&format_type=user
    def case_player_info
      if request.format.json?
        if params[:format_type] == "user"
          raise "must not happen"
          if !current_swars_user
            render json: {}, status: :not_found
            return
          end
          if params[:try_fetch] == "true"
            import_process_any
          end
          render json: current_swars_user.user_info(params.to_unsafe_h.to_options)
        end
      end
    end

    def case_swars_search
      if request.format.json?
        import_process_any
        render json: js_index_options.as_json
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
      current_swars_user_key && params[:page].blank? && !from_crawl_bot?
    end

    def js_index_options
      {
        :xnotice                => @xnotice,
        :import_enable_p        => import_enable?,
        :current_swars_user_key => current_swars_user&.key,
        :viewpoint              => current_viewpoint,
      }.merge(super)
    end

    # 検索窓に棋譜URLが指定されたときの対局キー
    def main_battle_key
      @main_battle_key ||= yield_self do
        if query = params[:query].presence
          if battle_url = BattleUrlExtractor.new(query).battle_url
            battle_url.battle_key
          end
        end
      end
    end

    def import_process_any
      if main_battle_key
        Swars::Importer::BattleImporter.new(key: main_battle_key).run
      else
        many_import_process
      end
    end

    def many_import_process
      if import_enable?
        x_delete_process

        @before_count = nil
        @after_count = nil
        if current_swars_user
          @before_count = current_swars_user.battles.count
        else
          # 初回インポートでは User レコードが存在しない
        end

        # 連続クロール回避
        # 開発環境で回避させるには rails dev:cache しておくこと
        # 失敗時は current_swars_user ある場合にのみスキップする
        # そうしないと「もしかして」メッセージの2度目が表示されない
        @import_errors = []
        @import_success = Importer::ThrottleImporter.new(import_params).run
        import_error_message_build
        if !@import_success && current_swars_user
          @xnotice.add("さっき取得したばかりです", type: "is-warning", development_only: true)
          return
        end

        # ユーザーが見つからなかったということはウォーズIDを間違えている
        if !current_swars_user
          message = UserKeySuggestion.message_for(current_swars_user_key)
          SlackAgent.notify(emoji: ":NOT_FOUND:", subject: "ウォーズID不明", body: "#{current_swars_user_key.inspect} #{message}")
          @xnotice.add(message, type: "is-warning", duration_sec: 5)
          return
        end

        # remove_instance_variable(:@current_swars_user) # current_swars_user.battles をリロードする目的

        @after_count = current_swars_user.battles.count
        if hit_count.zero?
          @xnotice.add("新しい棋譜は見つかりませんでした", type: "is-dark", development_only: true)
        else
          @xnotice.add("#{hit_count}件、新しく見つかりました", type: "is-info")
        end
        current_swars_user.search_logs.create!

        if Rails.env.development?
          slack_notify(subject: "検索", body: "#{current_swars_user_key} #{hit_count}件")
        end
      end
    end

    def import_page_max
      @import_page_max ||= (params[:page_max].presence || 1).to_i
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

    # http://localhost:3000/w.json?query=https://shogiwars.heroz.jp/games/alice-bob-20200101_123403
    # http://localhost:4000/swars/search?query=https://shogiwars.heroz.jp/games/alice-bob-20200101_123403
    def current_swars_user_key
      @current_swars_user_key ||= params[:user_key].presence || query_info.swars_user_key_extractor.extract
    end

    def exclude_column_names
      ["meta_info", "csa_seq"]
    end

    def current_scope
      @current_scope ||= current_model.search(params.merge({
            :user            => current_swars_user,
            :query_info      => query_info,
            :main_battle_key => main_battle_key,
          }))
    end

    def current_index_scope
      @current_index_scope ||= yield_self do
        s = current_scope
        if !primary_key_exist?
          s = s.none
        end
        s
      end
    end

    # main_battle_key に対応するレコード
    def primary_record
      @primary_record ||= yield_self do
        if main_battle_key
          Swars::Battle.find_by(key: main_battle_key)
        end
      end
    end

    def sort_column_default
      "battled_at"
    end

    def sort_scope(s)
      if md = sort_column.match(/\A(?:membership)\.(?<column>\w+)/)
        if current_swars_user
          o = current_swars_user.memberships.order(md[:column] => sort_order)
          s = s.joins(:memberships).merge(o)
        end
      else
        s = super(s) # Battle のカラムに対するソート
      end
      s
    end

    private

    def primary_key_exist?
      if Rails.env.development?
        if params[:all]
          return true
        end
      end

      current_swars_user || main_battle_key || query_info.lookup(:ids)
    end

    def x_delete_process
      if Rails.env.development? || Rails.env.test?
        if params[:x_destroy_all]
          x_destroy_all
        end
      end
    end

    def x_destroy_all
      ForeignKey.disabled do
        User.destroy_all
        Battle.destroy_all
        if instance_variable_defined?(:@current_swars_user)
          remove_instance_variable(:@current_swars_user)
        end
      end
    end

    def import_params
      {
        :user_key                => current_swars_user_key,
        :page_max                => import_page_max,
        :throttle_cache_clear    => params[:throttle_cache_clear],
        :bs_error_capture_fake   => params[:bs_error_capture_fake],
        :bs_error_capture_block        => -> error { @import_errors << error },
        :SwarsFormatIncompatible => params[:SwarsFormatIncompatible],
        :RaiseConnectionFailed   => params[:RaiseConnectionFailed],
        :SwarsUserNotFound       => params[:SwarsUserNotFound],
        :SwarsBattleNotFound     => params[:SwarsBattleNotFound],
      }
    end

    # 確認方法
    # http://localhost:3000/w?query=DevUser1&bs_error_capture_fake=true&throttle_cache_clear=true
    def import_error_message_build
      if @import_errors.present?
        subject = "【ウォーズ棋譜不整合】"
        SystemMailer.notify(fixed: true, subject: subject, body: error_message_body).deliver_later

        body = error_message_body.gsub(/\R/, "<br>")
        @xnotice.add(body, type: "is-danger", method: :dialog, title: "棋譜の不整合")
      end
    end

    def error_message_body
      @import_errors.collect { |e|
        [
          e[:error].message.strip,
          BattleKey.create(e[:key]).originator_url,
        ].collect { |e| "#{e}\n" }.join
      }.join("\n")
    end

    def hit_count
      if @after_count
        if @before_count
          @after_count - @before_count
        else
          @after_count
        end
      end
    end
  end
end
