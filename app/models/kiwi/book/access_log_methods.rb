module Kiwi
  class Book
    concern :AccessLogMethods do
      included do
        has_many :access_logs, class_name: "Kiwi::AccessLog", dependent: :destroy # アクセス記録たち
        has_many :access_log_users, through: :access_logs, source: :user          # アクセスしたユーザーたち
      end

      # def kiwi_access_log_pong_broadcast
      #   ActionCable.server.broadcast("kiwi/book_room_channel/#{id}", {bc_action: :kiwi_access_log_pong_broadcast, bc_params: { pong: "OK" }})
      # end
    end
  end
end
