class CpuBattleChannel < ApplicationCable::Channel
  def subscribed
    stream_from "cpu_battle_channel_#{params[:session_hash]}"
  end
end
