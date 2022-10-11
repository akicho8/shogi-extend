module Api
  class ShareBoardsController < ::Api::ApplicationController
    include ShareBoardControllerMethods

    # http://localhost:3000/api/share_board/kifu_mail.json
    def kifu_mail
      KifuMailer.basic_mail(params.to_unsafe_h.deep_symbolize_keys.merge(user: current_user)).deliver_later
      render json: { message: "#{current_user.email} 宛に送信しました" }
    end
  end
end
