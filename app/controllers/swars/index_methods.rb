module Swars
  concern :IndexMethods do
    def index
      [
        :case_kento_api,
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
      hv = {
        :xnotice                => @xnotice,
        :import_enable_p        => import_enable?,
        :current_swars_user_key => current_swars_user&.key,
        :viewpoint              => current_viewpoint,
      }
      if Rails.env.local?
        if params[:stat]
          hv[:stat] = Battle.stat
        end
      end
      hv.merge(super)
    end

    def import_process_any
      if primary_battle_key
        Swars::Importer::BattleImporter.new(key: primary_battle_key).call
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

        if current_swars_user_key
          # 連続クロール回避
          # 開発環境で回避させるには rails dev:cache しておくこと
          # 失敗時は current_swars_user ある場合にのみスキップする
          # そうしないと「もしかして」メッセージの2度目が表示されない
          @import_errors = []
          @import_success = Importer::ThrottleImporter.new(import_params).call
          import_error_message_build
          if !@import_success && current_swars_user
            @xnotice.add("さっき取得したばかりです", type: "is-warning", development_only: true)
            return
          end
        end

        # ユーザーが見つからなかったということはウォーズIDを間違えている
        if !current_swars_user
          message = UserKeySuggestion.message_for(current_swars_user_key)
          AppLog.info(emoji: ":NOT_FOUND:", subject: "ウォーズID不明", body: "#{current_swars_user_key.inspect} #{message}")
          @xnotice.add(message, type: "is-warning", duration_sec: 5)
          return
        end

        # remove_instance_variable(:@current_swars_user) # current_swars_user.battles をリロードする目的

        if current_swars_user
          @after_count = current_swars_user.battles.count
          if hit_count.zero?
            @xnotice.add("新しい棋譜は見つかりませんでした", type: "is-dark", development_only: true)
          else
            @xnotice.add("#{hit_count}件、新しく見つかりました", type: "is-info")
          end
          current_swars_user.search_logs.create!
          AppLog.debug(subject: "検索", body: "#{current_swars_user_key} #{hit_count}件")
        end
      end
    end

    def look_up_to_page_x
      @look_up_to_page_x ||= (params[:look_up_to_page_x].presence || 1).to_i
    end

    def current_musers
      @current_musers ||= query_info.lookup(:muser)
    end

    def current_ms_tags
      @current_ms_tags ||= query_info.lookup(:ms_tag)
    end

    def exclude_column_names
      ["meta_info", "csa_seq"]
    end

    ################################################################################

    def sort_column_default
      "battled_at"
    end

    def sort_scope(s)
      if md = sort_column.match(/\A(?:membership)\.(?<column>\w+)/)
        s = s.joins(:memberships).merge(Membership.order(md[:column] => sort_order))
      else
        s = super(s) # Battle のカラムに対するソート
      end
      s
    end

    ################################################################################

    private

    def x_delete_process
      if Rails.env.local?
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
        :look_up_to_page_x       => look_up_to_page_x,
        :throttle_cache_clear    => params[:throttle_cache_clear],
        :bs_error_capture_fake   => params[:bs_error_capture_fake],
        :bs_error_capture_block  => -> error { @import_errors << error },
        :SwarsFormatIncompatible => params[:SwarsFormatIncompatible],
        :RaiseConnectionFailed   => params[:RaiseConnectionFailed],
        :SwarsUserNotFound       => params[:SwarsUserNotFound],
        :BattleNotFound     => params[:BattleNotFound],
      }
    end

    # 確認方法
    # http://localhost:3000/w?query=DevUser1&bs_error_capture_fake=true&throttle_cache_clear=true
    def import_error_message_build
      if @import_errors.present?
        AppLog.error(subject: "ウォーズ棋譜不整合", body: error_message_body)

        body = error_message_body.gsub(/\R/, "<br>")
        @xnotice.add(body, type: "is-danger", method: :dialog, title: "棋譜の不整合")
      end
    end

    def error_message_body
      @import_errors.collect { |e|
        [
          e[:error].message.strip,
          BattleKey.create(e[:key]).official_url,
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
