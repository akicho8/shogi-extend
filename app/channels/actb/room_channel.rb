module Actb
  class RoomChannel < BaseChannel
    def subscribed
      raise ArgumentError, params.inspect unless room_id

      stream_from "actb/room_channel/#{room_id}"

      if current_user
        redis.sadd(:room_user_ids, current_user.id)
        room_user_ids_broadcast
        current_user.room_speak(current_room, "*入室しました")
      else
        reject
      end

      current_room.battle_create_with_members! # FIXME: 部屋を subscribed したときに2つのバトルが作られている？
      # --> app/jobs/actb/battle_broadcast_job.rb --> battle_broadcasted --> app/javascript/actb_app/application_room.js
    end

    def unsubscribed
      if current_user
        redis.srem(:room_user_ids, current_user.id)
        room_user_ids_broadcast

        current_user.room_speak(current_room, "*退出しました")
      end
    end

    # for test
    def room_users
      room_user_ids.collect { |e| User.find(e) }
    end

    private

    # def battle_leave_handle2(membership)
    #   membership.user.room_speak(current_room, "*room_unsubscribed")
    #   broadcast(:room_member_disconnect_broadcasted, membership_id: membership.id)
    # end

    def room_id
      params["room_id"]
    end

    def current_room
      Room.find(room_id)
    end

    def broadcast(bc_action, bc_params)
      raise ArgumentError, bc_params.inspect unless bc_params.values.all?
      ActionCable.server.broadcast("actb/room_channel/#{room_id}", {bc_action: bc_action, bc_params: bc_params})
    end
  end
end
