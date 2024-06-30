module Admin
  class ApplicationController < ::ApplicationController
    before_action :admin_login_required
  end
end
