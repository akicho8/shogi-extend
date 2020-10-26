module Api
  class ServiceInfosController < ::Api::ApplicationController
    # curl http://localhost:3000/api/service_infos
    def index
      render json: ServiceInfo
    end
  end
end
