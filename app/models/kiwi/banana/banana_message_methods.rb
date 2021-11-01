module Kiwi
  class Banana
    concern :BananaMessageMethods do
      included do
        has_many :banana_messages, class_name: "Kiwi::BananaMessage", dependent: :destroy # コメント
        has_many :banana_message_users, through: :banana_messages, source: :user          # コメントしたユーザー(複数)
      end

      def kiwi_banana_message_pong_broadcast
        ActionCable.server.broadcast("kiwi/banana_room_channel/#{id}", {bc_action: :kiwi_banana_message_pong_broadcast, bc_params: { pong: "OK" }})
      end
    end
  end
end
