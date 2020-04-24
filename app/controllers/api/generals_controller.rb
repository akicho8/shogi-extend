module Api
  class GeneralsController < ::Api::ApplicationController
    # http://localhost:3000/api/general/any_source_to_sfen?any_source=68S
    def any_source_to_sfen
      info = Bioshogi::Parser.parse(params[:any_source])
      render json: { sfen: info.to_sfen, turn_max: info.mediator.turn_info.turn_offset }
    end
  end
end
