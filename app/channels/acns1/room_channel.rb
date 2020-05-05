class Acns1::RoomChannel < ApplicationCable::Channel
  def subscribed
    p ["#{__FILE__}:#{__LINE__}", __method__, params]
    stream_from "acns1/room_channel/#{params['room_id']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    Acns1::Message.create!(body: data['message'], user: current_user, room_id: params['room_id'])
  end
end
