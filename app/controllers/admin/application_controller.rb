module Admin
  class ApplicationController < ::ApplicationController
    before_action :request_http_basic_authentication, :if => proc { params[:request_http_basic_authentication] }
    before_action :admin_login_required
  end
end
