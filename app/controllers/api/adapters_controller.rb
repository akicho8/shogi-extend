module Api
  class AdaptersController < ::Api::ApplicationController
    # curl -d _method=post http://0.0.0.0:3000/api/adapter/record_create.json
    def record_create
      record = FreeBattle.create!(kifu_body: params[:input_text])
      render json: { record: record.as_json(methods: :all_kifs) }
    end
  end
end
