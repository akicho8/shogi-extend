module Kiwi
  class Book
    concern :BookMessageMethods do
      included do
        has_many :book_messages, class_name: "Kiwi::BookMessage", dependent: :destroy # コメント
        has_many :book_message_users, through: :book_messages, source: :user          # コメントしたユーザー(複数)
      end

      def kiwi_book_message_pong_broadcast
        ActionCable.server.broadcast("kiwi/book_room_channel/#{id}", {bc_action: :kiwi_book_message_pong_broadcast, bc_params: { pong: "OK" }})
      end
    end
  end
end
