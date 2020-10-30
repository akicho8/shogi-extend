module Api
  class AdaptersController < ::Api::ApplicationController
    # curl -d _method=post http://0.0.0.0:3000/api/adapter/record_create.json
    def record_create
      record = FreeBattle.create!(kifu_body: params[:input_text])
      render json: { record: record.as_json(methods: :all_kifs) }
    end

    # curl http://0.0.0.0:3000/api/adapter/formal_sheet.json?key=xxx
    def formal_sheet
      record = FreeBattle.find_by!(key: params[:key])
      # record = FreeBattle.first
      render json: record.battle_decorator(params.to_unsafe_h.to_options.merge(view_context: view_context))
    end
  end
end
