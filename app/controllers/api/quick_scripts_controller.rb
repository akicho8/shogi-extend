module Api
  class QuickScriptsController < ::Api::ApplicationController
    before_action :admin_login_required, :if => proc {
      QuickScript::QsGroupInfo.lookup(params[:qs_group_key])&.admin_only
    }

    def show
      QuickScript::Main.dispatch(params.to_unsafe_h.symbolize_keys, {
          :admin_user         => admin_user,
          :current_user       => current_user,
          :controller         => self,
          :axios_process_type => axios_process_type,
        })
    end
  end
end
