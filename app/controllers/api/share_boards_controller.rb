module Api
  class ShareBoardsController < ::Api::ApplicationController
    include ShareBoardControllerMethods

    # http://localhost:3000/api/share_board/remote_notify2.json
    def remote_notify2
      KifuMailer.basic_mail(params.to_unsafe_h.to_options.merge(user: current_user)).deliver_later
      render json: {}
    end
  end
end
