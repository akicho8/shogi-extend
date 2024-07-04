module Api
  class QuickScriptsController < ::Api::ApplicationController
    before_action :admin_login_required, :if => proc { QuickScript::QsGroupInfo.lookup(params[:qs_group_key])&.admin_only }

    # http://localhost:4000/bin/dev/download
    # http://localhost:3000/api/bin/dev/download
    # http://localhost:3000/api/bin/dev/download.csv
    def show
      # redirect_to "https://example.com/", allow_other_host: true
      # return
      # raise request.format.to_sym.inspect

      QuickScript::Main.fetch(params.to_unsafe_h.symbolize_keys, admin_user: admin_user, current_user: current_user, controller: self).render_all

      # object = QuickScript::Main.fetch(params.to_unsafe_h.symbolize_keys, admin_user: admin_user, current_user: current_user, controller: self)
      # respond_to do |format|
      #   format.json { render json: object }
      #   format.csv { send_data object.csv_content, filename: object.csv_filename }
      #   # format.all { render json: object }
      #   format.all { render plain: __FILE__ }
      # end
    end
  end
end
