module Acns3
  class SchoolChannel < BaseChannel
    delegate :online_user_ids, :online_users, to: "self.class"

    class << self
      def online_user_ids
        redis.smembers(:online_user_ids).collect(&:to_i)
      end

      def online_users
        online_user_ids.collect { |e| Colosseum::User.find(e) }
      end
    end

    ################################################################################

    def subscribed
      stream_from "acns3/school_channel"

      if current_user
        redis.sadd(:online_user_ids, current_user.id)
        all_broadcast
      end
    end

    def unsubscribed
      if current_user
        redis.srem(:online_user_ids, current_user.id)
        all_broadcast
      end
    end

    private

    def all_broadcast
      ActionCable.server.broadcast("acns3/school_channel", online_user_ids: online_user_ids, room_user_ids: room_user_ids)
    end
  end
end
