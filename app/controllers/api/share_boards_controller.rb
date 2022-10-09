module Api
  class ShareBoardsController < ::Api::ApplicationController
    include ShareBoardControllerMethods

    # http://localhost:3000/api/share_board/kifu_notify.json
    def kifu_notify
      KifuMailer.basic_mail(params.to_unsafe_h.deep_symbolize_keys.merge(user: current_user)).deliver_later
      render json: {}
    end
  end
end
