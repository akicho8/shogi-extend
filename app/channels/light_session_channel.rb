class LightSessionChannel < ApplicationCable::Channel
  def subscribed
    stream_from "light_session_channel_#{params[:custom_session_id]}"
  end
end
