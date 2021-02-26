module Emox
  class RoomChannel < BaseChannel
    include ActiveUsersNotifyMethods

    class << self
      def redis_key
        :emox_room_user_ids
      end
    end

    def subscribed
      return reject unless current_user
      raise ArgumentError, params.inspect unless room_id

      stream_from "emox/room_channel/#{room_id}"
      self.class.active_users_add(current_user)

      if once_run("emox/rooms/#{current_room.id}/first_battle_create")
        battle = current_room.battle_create_with_members!
        # --> app/jobs/emox/battle_broadcast_job.rb --> battle_broadcasted --> app/javascript/emox_app/application_room.js
      end
    end

    def unsubscribed
      self.class.active_users_delete(current_user)

      # 部屋を閉じたら閉じた時間を end_at に入れておく
      # べつに入れておく必要はないがデバッグしやすいように入れておく
      if current_room.end_at.blank?
        if once_run("emox/rooms/#{current_room.id}/disconnect")
          current_room.update!(end_at: Time.current)
        end
      end
    end

    def emotion_handle(data)
      broadcast(:emotion_handle_broadcasted, data)
    end

    private

    def room_id
      params["room_id"]
    end

    def current_room
      Room.find(room_id)
    end

    def broadcast(bc_action, bc_params)
      raise ArgumentError, bc_params.inspect unless bc_params.values.all?
      ActionCable.server.broadcast("emox/room_channel/#{room_id}", {bc_action: bc_action, bc_params: bc_params})
    end
  end
end
