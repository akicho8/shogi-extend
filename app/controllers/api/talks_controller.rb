module Api
  class TalksController < ::Api::ApplicationController
    skip_forgery_protection

    # curl 'http://localhost:3000/api/talk.json?source_text=こんにちは&full_url=true'
    def show
      render json: Talk.new(params.permit!.to_h.symbolize_keys)
    end

    def create
      # config.headers.common['foo'] = "bar"
      # request.headers["foo"] # => "bar"
      render json: Talk.new(params.permit!.to_h.symbolize_keys)
    end
  end
end
