module Api
  class TalksController < ::Api::ApplicationController
    skip_forgery_protection

    # curl -X POST --data "{source_text: 'Hello'}" http://localhost:3000/api/talk.json
    # render json: Talk.create(source_text: "こんにちは")
    # # => {"browser_path":"/system/talk/main/df/a4/dfa49915a273d5639f1c7fbb237af8ec.mp3"}
    def create
      render json: Talk.create(params.to_unsafe_h.symbolize_keys)
    end
  end
end
