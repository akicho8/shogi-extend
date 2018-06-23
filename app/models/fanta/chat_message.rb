module Fanta
  class ChatMessage < ApplicationRecord
    belongs_to :user
    belongs_to :battle

    scope :latest_list, -> { order(:created_at) } # チャットルームに表示する最新N件

    # 非同期にするため
    # after_create_commit do
    #   ChatMessageBroadcastJob.perform_later(self)
    # end
  end
end
