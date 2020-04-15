class Acns2::RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "acns2/room_channel/#{params["room_id"]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, current_user&.name])
  end

  def speak(data)
    Acns2::Message.create!(body: data["message"], user: current_user, room_id: params["room_id"])

    Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, data])

    room = Acns2::Room.find(params["room_id"])
    if message = room.messages.where(user: current_user).order(created_at: :desc).first
      if message.body.include?("g")
        ActiveRecord::Base.transaction do
          membership = room.memberships.find_by!(user: current_user)
          membership.judge_key = :win
          membership.save!

          membership2 = (room.memberships - [membership]).first
          membership2.judge_key = :lose
          membership2.save!
        end

        json = room.as_json(root: true, only: [:id], include: { memberships: { only: [:id, :judge_key], include: {user: { only: [:id, :name] }} } })
        ActionCable.server.broadcast("acns2/room_channel/#{params["room_id"]}", json.merge(mode_change: "room_owari"))
      end
    end
  end
end
