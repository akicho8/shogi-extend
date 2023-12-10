module ShareBoard
  class ChatMessageLoader

    def initialize(params)
      @params = params
    end

    # GET http://localhost:3000/api/share_board/chat_message_loader?room_code=dev_room
    # GET http://localhost:3000/api/share_board/chat_message_loader?room_code=xxx
    # GET https://www.shogi-extend.com/api/share_board/chat_message_loader?room_code=5%E6%9C%88%E9%8A%80%E6%B2%B3%E6%88%A6
    def call
      room = Room.find_or_create_by!(key: @params[:room_code])

      # room.save!
      # user = ShareBoard::User.create!
      # chot_message = room.chot_messages.create!(user: user, content: user.chot_messages_count.next.to_s)  # => #<ShareBoard::ChotMessage id: 57, room_id: 1, user_id: 1, content: "a", created_at: "2023-12-10 10:25:50.000000000 +0900", updated_at: "2023-12-10 10:25:50.000000000 +0900">

      room.as_json({
          only: [
            :id,
            # :key,
          ],
          include: {
            chot_messages: ChotMessage::JSON_TYPE1,
          },
        })
    end

    private

    # MEMBERSHIP_STRUCT_TYPE1 = {
    #   include: {
    #     user: {
    #       only: [
    #         :name,
    #       ],
    #     },
    #   },
    # }
  end
end
