module Acns2
  class SchoolChannel < BaseChannel
    def subscribed
      stream_from "acns2/school_channel"

      if current_user
        redis.sadd(:online_user_ids, current_user.id)
      end

      all_broadcast
    end

    def unsubscribed
      if current_user
        redis.srem(:online_user_ids, current_user.id)
      end

      all_broadcast
    end

    private

    def all_broadcast
      ActionCable.server.broadcast("acns2/school_channel", online_user_ids: online_user_ids, room_user_ids: room_user_ids)
    end

    def online_user_ids
      redis.smembers(:online_user_ids)
    end
  end
end
