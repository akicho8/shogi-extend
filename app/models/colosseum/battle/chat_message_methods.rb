module Colosseum::Battle::ChatMessageMethods
  extend ActiveSupport::Concern

  included do
    cattr_accessor(:chat_display_lines_limit) { 12 }

    has_many :chat_messages, dependent: :destroy do
      def limited_latest_list
        latest_list.limit(chat_display_lines_limit)
      end
    end
  end

  def chat_say(user, message, msg_options = {})
    user.chat_say(battle, message, msg_options)
  end
end
