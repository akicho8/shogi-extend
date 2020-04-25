class BattleChannel < ApplicationCable::Channel
  def subscribed
    stream_from channel_key
    if current_user
      stream_for current_user
    end
  end

  # js 側では無理でも ruby 側だと接続切れの処理が書ける
  def unsubscribed

    if Rails.env.test?
      p ["#{__FILE__}:#{__LINE__}", __method__, "room_out しない"]
      return
    end

    room_out({})
  end

  # ../javascript/packs/battle.js の App.battle.send({full_sfen: response.data.sfen}) に対応して呼ばれる
  # アクションを指定しなかったときに対応する Rails 側のアクションらしいがこの部分のコードが肥大化しそうなので使わない
  def receive(data)
  end

  # 疑問: transmit(...) は ActionCable.server.broadcast(channel_key, ...)  と同じか？ → 違うっぽい。反応しないクライアントがある

  # transmit action: :update_count, count: 1 とすると
  # data["action"] // => "update_count"
  # data["count"]  // => 1
  # で参照できる

  # 死活監視
  periodically every: 60.seconds do
    transmit action: :custom_ping
  end

  ################################################################################

  # 人間が指した直後のトリガー
  def play_mode_advanced_full_moves_sfen_set(data)
    battle.play_mode_advanced_full_moves_sfen_set(data)
  end

  def chat_say(data)
    if current_user
      current_user.chat_say(battle, data["message"], data["msg_options"] || {})
    end
  end

  def room_in(data)
    if current_user
      current_user.room_in(battle)
    end
  end

  def room_out(data)
    if current_user
      current_user.room_out(battle)
    end
  end

  def time_up(data)
    battle.time_up(data)
  end

  def give_up(data)
    battle.give_up(data)
  end

  def fool_god(data)
    battle.next_run
  end

  # 持ち時間を使いきった時
  def countdown_flag_on(data)
    battle.countdown_flag_on(data)
  end

  def next_run_if_robot
    battle.next_run_if_robot
  end

  def custom_pong(data)
    user = Colosseum::User.find(data["user_id"])
    logger.info("#{user.name}さんは生きています")
  end

  private

  def channel_key
    "battle_channel_#{params[:battle_id]}"
  end

  def battle
    # メモ化してはいけない
    # メモ化すると play_mode_advanced_full_moves_sfen_set のときに clock_counts_update のなかで battle.clock_counts が片方の情報しか持ってない状態になり、相手の情報が毎回が元に戻ってしまう
    Colosseum::Battle.find(params[:battle_id])
  end
end
