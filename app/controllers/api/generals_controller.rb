module Api
  class GeneralsController < ::Api::ApplicationController
    # curl http://localhost:3000/api/general/any_source_to?any_source=68S
    # curl http://localhost:3000/api/general/any_source_to -d "any_source=68S"
    def any_source_to
      info = Bioshogi::Parser.parse(params[:any_source])
      render json: { body: info.public_send("to_#{to_format}"), turn_max: info.mediator.turn_info.turn_offset }
    end

    private

    def to_format
      params[:to_format].presence
    end
  end
end
