module Api
  class WkbkController < ::Api::ApplicationController
    include BookMod
    include ArticleMod

    include SortMod
    include ZipDlMod
    include DebugMod

    def show
      update
    end

    def update
      render json: public_send(params[:remote_action])
    end
  end
end
