module Acns3
  class SchoolChannel < BaseChannel
    delegate :online_user_ids, to: "self.class"

    def self.online_user_ids
      redis.smembers(:online_user_ids)
    end

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
