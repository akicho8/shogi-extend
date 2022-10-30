module Api
  class TalksController < ::Api::ApplicationController
    skip_forgery_protection

    # curl -X POST --data "{source_text: 'Hello'}" http://localhost:3000/api/talk.json
    def create
      render json: Talk.create(params.to_unsafe_h.symbolize_keys)
    end
  end
end
