module Actf
  class RoomChannel < BaseChannel
    def subscribed
      raise ArgumentError, params.inspect unless params["room_id"]

      stream_from "actf/room_channel/#{params["room_id"]}"

      if current_user
        redis.sadd(:room_user_ids, current_user.id)
        room_user_ids_broadcast
      else
        reject
      end
    end

    def unsubscribed
      if current_user
        redis.srem(:room_user_ids, current_user.id)
        room_user_ids_broadcast
      end

      katimashita(:lose, :disconnect)
    end

    def speak(data)
      data = data.to_options

      message = Message.create!(body: data[:message], user: current_user, room_id: params["room_id"])

      # if message = room.messages.where(user: current_user).order(created_at: :desc).first
      if md = message.body.to_s.match(/\/(?<command_line>.*)/)
        args = md["command_line"].split
        command = args.shift
        if command == "win"
          katimashita(:win)
        end
        if command == "lose"
          katimashita(:lose)
        end
      end
    end

    # TODO: js 側から直接 received に送れないのか？
    def progress_info_share(data)
      data = data.to_options

      info = { membership_id: data[:membership_id], quest_index: data[:quest_index] }

      # 一応保存しておく(あとで取るかもしれない)
      current_room.memberships.find(data[:membership_id]).update!(quest_index: data[:quest_index])

      # 問題の解答数を上げる
      if id = data[:quest_id]
        Question.find(id).increment!(:o_count)
      end

      # こちらがメイン
      ActionCable.server.broadcast("actf/room_channel/#{params["room_id"]}", {progress_info_share: info})
    end

    # <-- app/javascript/actf_app.vue
    def katimasitayo(data)
      katimashita(:win, :all_clear)
    end

    def katimashita(judge_key, final_key)
      room = current_room

      if room.final_key
        Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, "すでに終了している"])
        return
      end

      judge_info = JudgeInfo.fetch(judge_key)

      ActiveRecord::Base.transaction do
        m1 = room.memberships.find_by!(user: current_user)
        m2 = (room.memberships - [m1]).first

        m1.judge_key = judge_info.key
        m2.judge_key = judge_info.flip.key

        if m1.judge_key == "win"
          mm = [m1, m2]
        else
          mm = [m2, m1]
        end

        ab = mm.collect { |e| e.user.actf_profile.rating }
        ab = EloRating.rating_update2(*ab)
        ab = ab.collect(&:round)
        mm.each.with_index { |m, i| m.user.actf_profile.update!(rating: ab[i]) }

        mm.each(&:save!)
        room.update!(final_key: final_key)
      end

      room.reload

      memberships_user_ids_remove(room)

      # 終了時
      room_json = room.as_json(only: [:id], include: { memberships: { only: [:id, :judge_key, :rensho_count, :renpai_count, :quest_index], include: {user: { only: [:id, :name], methods: [:avatar_path], include: {actf_profile: { only: [:id, :rensho_count, :renpai_count, :rating, :rating_max, :rating_last_diff, :rensho_max, :renpai_max] } } } } }}, methods: [:final_info])
      ActionCable.server.broadcast("actf/room_channel/#{params["room_id"]}", {switch_to: "result", room: room_json})
      # --> app/javascript/actf_app.vue
    end

    def current_room
      Room.find(params["room_id"])
    end

    def room_user_ids_broadcast
      ActionCable.server.broadcast("actf/school_channel", room_user_ids: room_user_ids)
    end

    def memberships_user_ids_remove(room)
      room.memberships.each do |m|
        redis.srem(:room_user_ids, m.user.id)
      end
      room_user_ids_broadcast
    end

    def room_users
      room_user_ids.collect { |e| Colosseum::User.find(e) }
    end
  end
end
