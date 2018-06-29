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
  # アクションを指定しなかったときに対応する Rails 側のアクションらしいが、ごちゃごちゃになりそうなので使わない
  def receive(data)
  end

  # 定期的に呼ぶ処理が書ける
  periodically every: 30.seconds do
    # 疑問: transmit(...) は ActionCable.server.broadcast(channel_key, ...)  と同じか？ → 違うっぽい。反応しないクライアントがある
    transmit action: :update_count, count: 1
  end

  ################################################################################

  # 人間が指した直後のトリガー
  def play_mode_long_sfen_set(data)
    battle.play_mode_long_sfen_set(data)
  end

  # 発言
  # chat_say("message" => '<span class="has-text-info">退室しました</span>')
  def chat_say(data)
    chat_message = current_user.chat_messages.create!(battle: battle, message: data["message"])
    ActionCable.server.broadcast(channel_key, chat_message: ams_sr(chat_message))
  end

  # わざわざ ruby 側に戻してブロードキャストする意味がない気がする
  # JavaScript 側でそのまま自分以外にブロードキャストできればそれにこしたことはない → たぶん方法はある
  # def kifu_body_sfen_broadcast(data)
  #   # 未使用
  #   ActionCable.server.broadcast(channel_key, data)
  # end

  def room_in(data)
    current_user.room_in(battle)
  end

  def room_out(data)
    chat_say("message" => '<span class="has-text-info">退室しました</span>')
    current_user.room_out(battle)
  end

  def time_up_trigger(data)
    battle.time_up_trigger(data)
  end

  # 負ける人が申告する
  def give_up_trigger(data)
    battle.game_end(win_location_key: data["win_location_key"], last_action_key: "TORYO")
  end

  # # 先後をまとめて反転する
  # def location_flip_all(data)
  #   battle.memberships.each(&:location_flip!)
  #   memberships_update
  # end

  # 先後をまとめて反転する
  def countdown_mode_on(data)
    location = Warabi::Location.fetch(data["location_key"])
    battle.countdown_flags[location.key] = true
    battle.save!
  end

  private

  # # 部屋が抜けたときの状態も簡単に反映できるように全メンバー一気に送るのでよさそう
  # def memberships_update
  #   battle.reload # 部屋を抜けたときの状態が反映されるように reload が必要
  #   ActionCable.server.broadcast(channel_key, memberships: ams_sr(battle.memberships))
  # end

  def channel_key
    "battle_channel_#{params[:battle_id]}"
  end

  def battle
    @battle ||= Fanta::Battle.find(params[:battle_id])
  end

  # 自分対自分の場合もあるためメンバー情報は複数ある
  def current_memberships
    @current_memberships ||= battle.memberships.where(user: current_user)
  end
end
