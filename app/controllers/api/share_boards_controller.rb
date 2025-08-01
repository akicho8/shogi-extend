module Api
  class ShareBoardsController < ::Api::ApplicationController
    include ShareBoardControllerMethods

    # POST http://localhost:3000/api/share_board/battle_create.json
    def battle_create
      render json: ShareBoard::BattleCreate.new(params_with_user).call
    end

    # GET http://localhost:3000/api/share_board/dashboard.json?room_key=dev_room
    def dashboard
      render json: ShareBoard::Dashboard.new(params_with_user).call
    end

    # GET http://localhost:3000/api/share_board/chat_message_loader.json?room_key=dev_room
    def chat_message_loader
      render json: ShareBoard::Room.fetch(params[:room_key]).as_json_for_chat_message_loader(params_with_user)
    end

    # POST http://localhost:3000/api/share_board/kifu_mail.json
    def kifu_mail
      render json: ShareBoard::KifuMailSender.new(params_with_user).call
    end

    private

    def params_with_user
      params.to_unsafe_h.deep_symbolize_keys.merge(user: current_user)
    end
  end
end
