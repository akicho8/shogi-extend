module Api
  class ShareBoardsController < ::Api::ApplicationController
    include ShareBoardControllerMethods

    # POST http://localhost:3000/api/share_board/kifu_mail.json
    def kifu_mail
      KifuMailer.basic_mail(params.to_unsafe_h.deep_symbolize_keys.merge(user: current_user)).deliver_later
      render json: { message: "#{current_user.email} 宛に送信しました" }
    end

    # POST http://localhost:3000/api/share_board/battle_create.json
    def battle_create
      render json: ShareBoard::BattleCreate.new(params.to_unsafe_h.deep_symbolize_keys.merge(user: current_user)).call
    end

    # GET http://localhost:3000/api/share_board/dashboard.json?room_code=dev_room
    def dashboard
      render json: ShareBoard::Dashboard.new(params.to_unsafe_h.deep_symbolize_keys.merge(user: current_user)).call
    end
  end
end
