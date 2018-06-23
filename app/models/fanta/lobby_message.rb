module Fanta
  class LobbyMessage < ApplicationRecord
    belongs_to :user

    cattr_accessor(:chat_window_size) { 10 }

    scope :latest_list, -> { order(created_at: :desc).limit(chat_window_size) } # 実際に使うときは昇順表示なので reverse しよう

    # # 非同期にするため
    # after_create_commit do
    #   ChatMessageBroadcastJob.perform_later(self)
    # end
  end
end
