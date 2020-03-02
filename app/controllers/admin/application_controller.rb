module Admin
  class ApplicationController < ::ApplicationController
    before_action :request_http_basic_authentication, :if => -> { params[:request_http_basic_authentication] }
    before_action :admin_login_required

    private

    # スキップできるようにメソッド化
    def admin_login_required
      authenticate_or_request_with_http_basic do |name, password|
        retv = name.present? && password == admin_password
        Rails.cache.fetch(__method__, :expires_in => 30.minutes) do
          slack_message(key: "管理画面ログイン", body: [retv, name, password].inspect)
          nil
        end
        session.delete(:admin_user)
        if retv
          session[:admin_user] ||= name.presence || "(admin_user)"
        end
        retv
      end
    end

    def admin_password
      if Rails.env.test?
        return "password_for_test"
      end

      Rails.application.credentials[:admin_password]
    end

    helper_method :admin_user

    def admin_user
      session[:admin_user]
    end
  end
end
