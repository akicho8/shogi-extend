module Api
  class GeneralsController < ::Api::ApplicationController
    # curl http://localhost:3000/api/general/any_source_to?any_source=68S
    # curl http://localhost:3000/api/general/any_source_to -d "any_source=68S"
    def any_source_to
      info = Bioshogi::Parser.parse(params[:any_source], parser_options)
      body = info.public_send("to_#{to_format}", convert_options)
      turn_max = info.mediator.turn_info.turn_offset
      render json: { body: body, turn_max: turn_max }
    end

    private

    def parser_options
      options = {
        :typical_error_case => :embed,
      }

      [
        :candidate_enable,
        :validate_enable,
      ].each do |key|
        if params.has_key?(key)
          options[key] = boolean_cast(params[key])
        end
      end

      options
    end

    def to_format
      params[:to_format].presence
    end

    def convert_options
      {
        compact: true,
        no_embed_if_time_blank: true,
      }
    end
  end
end
