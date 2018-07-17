class BattleChannel < ApplicationCable::Channel
  def subscribed
    stream_from channel_key
    stream_for current_user
  end

  # js 側では無理でも ruby 側だと接続切れの処理が書ける
  def unsubscribed
    room_out({})
  end

  # ../javascript/packs/battle.js の App.battle.send({full_sfen: response.data.sfen}) に対応して呼ばれる
  # アクションを指定しなかったときに対応する Rails 側のアクションらしいがこの部分のコードが肥大化しそうなので使わない
  def receive(data)
  end

  # 定期的に呼ぶ処理が書ける
  periodically every: 60.seconds do
    # 疑問: transmit(...) は ActionCable.server.broadcast(channel_key, ...)  と同じか？ → 違うっぽい。反応しないクライアントがある
    transmit action: :update_count, count: 1
  end

  ################################################################################

  # 人間が指した直後のトリガー
  def play_mode_long_sfen_set(data)
    battle.play_mode_long_sfen_set(data)
  end

  def chat_say(data)
    current_user.chat_say(battle, data["message"], data["msg_options"] || {})
  end

  def room_in(data)
    current_user.room_in(battle)
  end

  def room_out(data)
    current_user.room_out(battle)
  end

  def time_up(data)
    battle.time_up(data)
  end

  def give_up(data)
    battle.give_up(data)
  end

  def hebokisin(data)
    battle.next_run
  end

  # 持ち時間を使いきった時
  def countdown_flag_on(data)
    battle.countdown_flag_on(data)
  end

  def next_run_if_robot
    battle.next_run_if_robot
  end

  private

  def channel_key
    "battle_channel_#{params[:battle_id]}"
  end

  def battle
    @battle ||= Colosseum::Battle.find(params[:battle_id])
  end
end
