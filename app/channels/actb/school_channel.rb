module Actb
  class SchoolChannel < BaseChannel
    include ActiveUserNotifyMod

    class << self
      def redis_key
        :school_user_ids
      end
    end

    ################################################################################

    # 接続と同時にオンラインユーザーとして登録し配信する
    def subscribed
      stream_from "actb/school_channel"
      self.class.active_users_add(current_user)
    end

    # 切断と同時にオンラインユーザーを解除して配信する
    def unsubscribed
      self.class.active_users_delete(current_user)
    end
  end
end
