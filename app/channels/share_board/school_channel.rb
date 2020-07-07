module ShareBoard
  class SchoolChannel < BaseChannel
    include ActiveUsersNotifyMod

    class << self
      def redis_key
        :school_user_ids
      end
    end

    ################################################################################

    # 接続と同時にオンラインユーザーとして登録し配信する
    def subscribed
      stream_from "share_board/school_channel"
      self.class.active_users_add(current_user)
    end

    # 切断と同時にオンラインユーザーを解除して配信する
    def unsubscribed
      self.class.active_users_delete(current_user)
      ShareBoard::Rule.matching_users_delete_from_all_rules(current_user)
    end
  end
end
