module Admin
  class ApplicationController < ::ApplicationController
    before_action :request_http_basic_authentication, :if => proc { params[:request_http_basic_authentication] }
    before_action :admin_login_required

    private

    # スキップできるようにメソッド化
    def admin_login_required
      session.delete(:admin_user)
      authenticate_or_request_with_http_basic do |name, password|
        retv = name.present? && password == Rails.application.credentials[:admin_password]
        if Rails.env.production? || Rails.env.test?
          Rails.cache.fetch(__method__, :expires_in => 30.minutes) do
            slack_message(key: "管理画面ログイン", body: [retv, name, password].inspect)
            nil
          end
        end
        if retv
          session[:admin_user] ||= name.presence || "(admin_user)"
        end
        retv
      end
    end

    helper_method :admin_user

    def admin_user
      session[:admin_user]
    end
  end
end
