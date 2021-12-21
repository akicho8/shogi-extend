module Api
  class AdaptersController < ::Api::ApplicationController
    # curl -d _method=post http://localhost:3000/api/adapter/record_create.json
    def record_create
      render json: FreeBattle.adapter_post(params.merge(current_user: current_user))
    end

    # curl http://localhost:3000/api/adapter/formal_sheet.json?key=xxx
    def formal_sheet
      record = FreeBattle.find_by!(key: params[:key], use_key: "adapter")
      render json: record.battle_decorator(params.to_unsafe_h.to_options.merge(view_context: view_context))
    end
  end
end
