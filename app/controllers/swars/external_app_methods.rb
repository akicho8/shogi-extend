module Swars
  concern :ExternalAppMethods do
    included do
      helper_method :current_external_app_info
      helper_method :external_app_mode?
    end

    def current_external_app_info
      ExternalAppInfo.fetch(current_external_app_key)
    end

    def external_app_mode?
      params[:latest_open_index]
    end

    private

    let :latest_open_limit do
      if v = params[:latest_open_index].presence
        [v.to_i.abs, 10].min.next
      end
    end

    def external_app_action1
      if params[:redirect_to_bookmarkable_page]
        slack_message(key: "ブクマ移動", body: current_swars_user_key)
        flash[:external_app_bm] = true
        redirect_to [:swars, :battles, params.to_unsafe_h.slice(:query, :latest_open_index, :external_app_key)]
      end
    end

    # このなかでリダイレクトすると白紙のページが開いてしまうためビューを表示つつリダイレクトしている
    # ぴよ将棋の場合、選択肢が出て、遷移をキャンセルすることもできるため、その方が都合が良い
    def external_app_action2
      if flash[:external_app_bm]
        return
      end

      if latest_open_limit
        if record = current_scope.order(battled_at: :desc).limit(latest_open_limit).last
          @external_app_url = current_external_app_info.external_url(self, record)
          slack_message(key: current_external_app_info.shortcut_name, body: current_swars_user_key)
        end
      end
    end

    def current_external_app_key
      params[:external_app_key] || "piyo_shogi"
    end
  end
end
