class Acns1::RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel_#{params['room_id']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    Acns1::Message.create!(body: data['message'], user: current_user, room_id: params['room_id'])
  end
end
