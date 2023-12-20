module ShareBoard
  concern :SessionUserMethods do
    included do
      has_many :share_board_chat_messages, class_name: "ShareBoard::ChatMessage", foreign_key: :session_user_id, dependent: :nullify # このユーザーがログインしているときに共有将棋盤で発言した ChatMessage の配列
    end
  end
end
