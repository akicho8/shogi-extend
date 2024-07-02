module Api
  class QuickScriptsController < ::Api::ApplicationController
    before_action :admin_login_required, :if => proc { QuickScript::SgroupInfo.lookup(params[:qs_group])&.admin_only }

    # http://localhost:4000/bin/foo?bar=baz
    # http://localhost:3000/api/quick_scripts/foo?bar=baz
    def show
      # redirect_to "https://example.com/", allow_other_host: true
      # return
      render json: QuickScript::Main.fetch(params.to_unsafe_h.symbolize_keys, admin_user: admin_user, current_user: current_user)
    end
  end
end
