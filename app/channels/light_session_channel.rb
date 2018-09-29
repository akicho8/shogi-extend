class LightSessionChannel < ApplicationCable::Channel
  def subscribed
    stream_from "light_session_channel_#{params[:session_hash]}"
  end
end
