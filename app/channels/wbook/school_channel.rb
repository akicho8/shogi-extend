# rails r "Wbook::SchoolChannel.active_users_clear"
# rails r "Wbook::RoomChannel.active_users_clear"
module Wbook
  class SchoolChannel < BaseChannel
    include ActiveUsersNotifyMod

    class << self
      def redis_key
        :wbook_school_user_ids
      end
    end

    ################################################################################

    # 接続と同時にオンラインユーザーとして登録し配信する
    def subscribed
      __event_notify__(__method__)
      return reject unless current_user

      stream_from "wbook/school_channel"
      self.class.active_users_add(current_user)
    end

    # 切断と同時にオンラインユーザーを解除して配信する
    def unsubscribed
      __event_notify__(__method__)
      self.class.active_users_delete(current_user)
      Wbook::Rule.matching_users_delete_from_all_rules(current_user)
    end
  end
end
