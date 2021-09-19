module Api
  class AppEntryInfosController < ::Api::ApplicationController
    # curl http://localhost:3000/api/app_entry_infos
    def index
      render json: AppEntryInfo
    end
  end
end
