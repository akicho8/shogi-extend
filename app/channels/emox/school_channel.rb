# rails r "Emox::SchoolChannel.active_users_clear"
# rails r "Emox::RoomChannel.active_users_clear"
module Emox
  class SchoolChannel < BaseChannel
    include ActiveUsersNotifyMod

    class << self
      def redis_key
        :emox_school_user_ids
      end
    end

    ################################################################################

    # 接続と同時にオンラインユーザーとして登録し配信する
    def subscribed
      return reject unless current_user

      stream_from "emox/school_channel"
      self.class.active_users_add(current_user)
    end

    # 切断と同時にオンラインユーザーを解除して配信する
    def unsubscribed
      self.class.active_users_delete(current_user)
      Emox::Rule.matching_users_delete_from_all_rules(current_user)
    end
  end
end
