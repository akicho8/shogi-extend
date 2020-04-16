class Acns2::RoomChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, current_user&.name, params])
    stream_from "acns2/room_channel/#{params["room_id"]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, current_user&.name])
    katimashita(:lose, :disconnect)
  end

  def speak(data)
    message = Acns2::Message.create!(body: data["message"], user: current_user, room_id: params["room_id"])

    Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, data])

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
  def totyu_info_share(data)
    Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, data])
    info = {membership_id: data["membership_id"], quest_index: data["quest_index"]}

    # 一応保存しておく(あとで取るかもしれない)
    current_room.memberships.find(data["membership_id"]).update!(quest_index: data["quest_index"])

    ActionCable.server.broadcast("acns2/room_channel/#{params["room_id"]}", {totyu_info_share: info})
  end

  # <-- app/javascript/acns2_sample.vue
  def katimasitayo(data)
    Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, data])
    katimashita(:win, :all_clear)
  end

  private

  def katimashita(judge_key, final_key)
    judge_info = Acns2::JudgeInfo.fetch(judge_key)

    room = current_room

    if room.end_at
      Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, data, "すでに終了している"])
      return
    end

    ActiveRecord::Base.transaction do
      membership = room.memberships.find_by!(user: current_user)
      membership.judge_key = judge_info.key
      membership.save!

      m = (room.memberships - [membership]).first
      m.judge_key = judge_info.flip.key
      m.save!

      room.update!(final_key: final_key)
    end

    room.reload              # 最新の memberships の情報を反映するため

    room_json = room.as_json(only: [:id], include: { memberships: { only: [:id, :judge_key, :rensho_count, :renpai_count], include: {user: { only: [:id, :name], methods: [:avatar_url] }} } }, methods: [:final_info])
    ActionCable.server.broadcast("acns2/room_channel/#{params["room_id"]}", {room_owari: true, room: room_json})
    # --> app/javascript/acns2_sample.vue
  end

  def current_room
    Acns2::Room.find(params["room_id"])
  end
end
