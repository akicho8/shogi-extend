module Actb
  class RoomChannel < BaseChannel
    def subscribed
      raise ArgumentError, params.inspect unless room_id

      stream_from "actb/room_channel/#{room_id}"

      # -> battle_broadcasted
      current_room.battles.create! do |e|
        e.rule_key = current_room.rule_key
        current_room.users.each do |user|
          e.memberships.build(user: user)
        end
      end
    end

    def unsubscribed
    end

    def speak(data)
      data = data.to_options
      if data[:message].start_with?("/")
        execution_interrupt_hidden_command(data[:message])
      else
        current_user.actb_room_messages.create!(body: data[:message], room: current_room)
      end
    end

    def execution_interrupt_hidden_command(str)
      # if message = room.messages.where(user: current_user).order(created_at: :desc).first
      if md = str.to_s.match(/\/(?<command_line>.*)/)
        args = md["command_line"].split
        command = args.shift
        # if command == "win"
        #   katimashita(:win)
        # end
        # if command == "lose"
        #   katimashita(:lose)
        # end
      end
    end

    def room_id
      params["room_id"]
    end

    def current_room
      Room.find(room_id)
    end
  end
end
