module Actb
  class SchoolChannel < BaseChannel
    delegate :online_user_ids, :online_users, to: "self.class"

    class << self
      def online_user_ids
        redis.smembers(:online_user_ids).collect(&:to_i)
      end

      def online_users
        online_user_ids.collect { |e| User.find(e) }
      end
    end

    ################################################################################

    def subscribed
      stream_from "actb/school_channel"

      if current_user
        redis.sadd(:online_user_ids, current_user.id)
        online_status
      end
    end

    def unsubscribed
      if current_user
        redis.srem(:online_user_ids, current_user.id)
        online_status
      end
    end

    private

    def online_status
      ActionCable.server.broadcast("actb/school_channel", bc_action: :online_status_broadcasted, bc_params: {online_user_ids: online_user_ids, room_user_ids: room_user_ids})
    end
  end
end
