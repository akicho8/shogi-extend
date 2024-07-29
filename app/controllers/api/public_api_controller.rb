module Api
  class PublicApiController < ::Api::ApplicationController
    def show
      render json: params.as_json
    end
  end
end
