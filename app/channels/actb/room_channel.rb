module Actb
  class RoomChannel < BaseChannel
    def subscribed
      raise ArgumentError, params.inspect unless room_id

      stream_from "actb/room_channel/#{room_id}"

      if current_user
        redis.sadd(:room_user_ids, current_user.id)
        room_user_ids_broadcast
      else
        reject
      end

      current_room.battles.create! do |e|
        e.rule_key = current_room.rule_key
        current_room.users.each do |user|
          e.memberships.build(user: user)
        end
      end # --> app/jobs/actb/battle_broadcast_job.rb --> battle_broadcasted --> app/javascript/actb_app/application_room.js
    end

    def unsubscribed
      if current_user
        redis.srem(:room_user_ids, current_user.id)
        room_user_ids_broadcast
      end
    end

    # for test
    def room_users
      room_user_ids.collect { |e| Colosseum::User.find(e) }
    end

    private

    def room_id
      params["room_id"]
    end

    def current_room
      Room.find(room_id)
    end
  end
end
