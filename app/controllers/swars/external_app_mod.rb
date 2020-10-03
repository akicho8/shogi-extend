# 動作手順
#
# 1. HTMLから  { query: "itoshinTV", latest_open_index: 0, external_app_setup: true, external_app_key: "piyo_shogi" } で飛ぶ
# 2. params[:external_app_setup] があれば flash[:external_app_setup] = true してビューへ
# 3. flash[:external_app_setup] があればビューでブックマークを促す
# 4. 次のアクセスで flash[:external_app_setup] は消えるので通常の検索が走る
# 5. params[:latest_open_index] があるので指定のレコードを external_app_key が指すアプリに渡す
#
module Swars
  concern :ExternalAppMod do
    # included do
    #   # helper_method :current_external_app_info
    #   # helper_method :external_app_mode?
    # 
    #   # cattr_accessor(:latest_open_limit_max) { 10 }
    # end

    # def current_external_app_info
    #   ExternalAppInfo.fetch(current_external_app_key)
    # end

    # private

    # let :latest_open_limit do
    #   if v = params[:latest_open_index].presence
    #     [v.to_i.abs, latest_open_limit_max].min.next
    #   end
    # end

    # def external_app_setup
    #   if params[:external_app_setup]
    #     flash[:external_app_setup] = true
    #     slack_message(key: "#{current_external_app_info.shortcut_name}セットアップ", body: current_swars_user_key)
    #     redirect_to [:swars, :battles, params.to_unsafe_h.slice(:query, :latest_open_index, :external_app_key)]
    #   end
    # end

    # # このなかでリダイレクトすると白紙のページが開いてしまうためビューを表示つつリダイレクトしている
    # # ぴよ将棋の場合、選択肢が出て、遷移をキャンセルすることもできるため、その方が都合が良い
    # def external_app_run
    #   if flash[:external_app_setup]
    #     return
    #   end
    #
    #   if latest_open_limit
    #     if record = current_scope.order(battled_at: :desc).limit(latest_open_limit).last
    #       # 開発環境を iPhone で確認する
    #       # ・これがないと @external_app_url が http://localhost:3000 から始まる
    #       # ・そうするとするとぴよ将棋から .kif にアクセスできない
    #       record.h = view_context
    #
    #       @external_app_url = current_external_app_info.external_url(record)
    #       slack_message(key: current_external_app_info.shortcut_name, body: current_swars_user_key)
    #       if current_external_app_info.redirect_in_controller
    #         redirect_to @external_app_url
    #       end
    #     end
    #   end
    # end
    #
    # def current_external_app_key
    #   params[:external_app_key] || "piyo_shogi"
    # end
  end
end
