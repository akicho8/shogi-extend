class LobbyChatMessage < ApplicationRecord
  belongs_to :chat_user

  # # 非同期にするため
  # after_create_commit do
  #   ChatArticleBroadcastJob.perform_later(self)
  # end

  def js_attributes
    JSON.load(to_json(include: [:chat_user]))
  end
end
