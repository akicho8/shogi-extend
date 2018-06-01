class ChatRoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from room_key
    stream_for current_chat_user
  end

  def unsubscribed
    # js 側では無理でも ruby 側だと接続切れの処理が書ける
    room_out({})
  end

  # /Users/ikeda/src/shogi_web/app/javascript/packs/chat_room.js の App.chat_room.send({kifu_body_sfen: response.data.sfen}) で呼ばれる
  # アクションを指定せずに send で呼ぶときに対応する Rails 側のアクションらしい
  # が、ごちゃごちゃになりそうなので使わない
  def receive(data)
  end

  # 定期的に呼ぶ処理が書ける
  periodically every: 30.seconds do
    # 疑問: transmit(...) は ActionCable.server.broadcast(room_key, ...)  と同じか？ → 違うっぽい。反応しないクライアントがある
    transmit action: :update_count, count: 1
  end

  ################################################################################

  def play_mode_long_sfen_set(data)
    current_location = Warabi::Location.fetch(data["current_location_key"])

    v = data["kifu_body"]
    info = Warabi::Parser.parse(v)
    begin
      mediator = info.mediator
    rescue => error
      chat_say("message" => "<span class=\"has-text-info\">#{error.message.lines.first.strip}</span>")
      current_chat_room.update!(end_at: Time.current, win_location_key: current_location.flip.key, last_action_key: "ILLEGAL_MOVE")
      game_end_broadcast
      return
    end

    # opponent_player: 今指した人
    # current_player:  次に指す人

    # 指した直後にもかかわらず王手の状態になっている -> 王手放置 or 自らピンを外した(自滅)
    if mediator.opponent_player.mate_danger?
      chat_say("message" => "<span class=\"has-text-info\">【反則】#{mediator.to_ki2_a.last}としましたが王手放置または自滅です</span>")
      current_chat_room.update!(end_at: Time.current, win_location_key: mediator.current_player.location.key, last_action_key: "ILLEGAL_MOVE")
      game_end_broadcast
      return
    end

    # ここからは棋譜として正しい

    kifu_body_sfen = mediator.to_sfen
    ki2_a = mediator.to_ki2_a

    current_chat_room.clock_counts[mediator.opponent_player.location.key].push(data["clock_counter"].to_i) # push でも AR は INSERT 対象になる
    current_chat_room.kifu_body_sfen = kifu_body_sfen
    current_chat_room.turn_max = mediator.turn_info.turn_max
    current_chat_room.save!

    broadcast_data = {
      turn_max: mediator.turn_info.turn_max,
      kifu_body_sfen: kifu_body_sfen,
      human_kifu_text: current_chat_room.human_kifu_text,
      last_hand: ki2_a.last,
      moved_chat_user_id: current_chat_user.id, # 操作した人(この人以外に盤面を反映する)
      clock_counts: current_chat_room.clock_counts,
    }

    ActionCable.server.broadcast(room_key, broadcast_data)

    # 合法手がない = 詰まされた
    hands = mediator.current_player.normal_all_hands.find_all { |e| e.legal_move?(mediator) }
    if hands.empty?
      current_chat_room.update!(end_at: Time.current, win_location_key: mediator.opponent_player.location.key, last_action_key: "TSUMI")
      game_end_broadcast
      return
    end
  end

  # 発言
  # chat_say("message" => '<span class="has-text-info">退室しました</span>')
  def chat_say(data)
    room_chat_message = current_chat_user.room_chat_messages.create!(chat_room: current_chat_room, message: data["message"])
    ActionCable.server.broadcast(room_key, room_chat_message: ams_sr(room_chat_message))
  end

  # わざわざ ruby 側に戻してブロードキャストする意味がない気がする
  # JavaScript 側でそのまま自分以外にブロードキャストできればそれにこしたことはない → たぶん方法はある
  # def kifu_body_sfen_broadcast(data)
  #   # 未使用
  #   ActionCable.server.broadcast(room_key, data)
  # end

  def room_name_changed(data)
    current_chat_room.update!(name: data["room_name"])
    ActionCable.server.broadcast(room_key, data)
  end

  def room_in(data)
    # 自分から部屋に入ったらマッチングを解除する
    current_chat_user.update!(matching_at: nil)

    # どの部屋にいるか設定
    current_chat_user.update!(current_chat_room: current_chat_room)

    # 部屋のメンバーとして登録(マッチング済みの場合はもう登録されている)
    # unless current_chat_room.chat_users.include?(current_chat_user)
    #   current_chat_room.chat_users << current_chat_user
    # end

    if current_chat_memberships.present?
      # 対局者
      current_chat_memberships.each do |e|
        e.update!(fighting_now_at: Time.current)
      end
    else
      # 観戦者
      unless current_chat_room.watch_users.include?(current_chat_user)
        current_chat_room.watch_users << current_chat_user
        current_chat_room.broadcast # counter_cache の watch_memberships_count を反映させるため
      end
    end

    if current_chat_room.end_at
    else
      # 自分が対局者の場合
      if current_chat_memberships.present?
        if current_chat_memberships.all? { |e| e.standby_at }
          # 入り直した場合
        else
          # 新規の場合
          current_chat_memberships.each do |e|
            e.update!(standby_at: Time.current)
          end
          if current_chat_room.chat_memberships.standby_enable.count >= current_chat_room.chat_memberships.count
            battle_start({})
          end
        end
      end
    end

    room_members_update
  end

  def room_out(data)
    chat_say("message" => '<span class="has-text-info">退室しました</span>')

    current_chat_user.update!(current_chat_room_id: nil)

    if current_chat_memberships.present?
      # 対局者
      # 切断したときにの処理がここで書ける
      # TODO: 対局中なら、残っている方がポーリングを開始して、10秒間以内に戻らなかったら勝ちとしてあげる
      current_chat_memberships.each do |e|
        e.update!(fighting_now_at: nil)
      end
    else
      # 観戦者
      current_chat_room.watch_users.destroy(current_chat_user)
      # ActionCable.server.broadcast(room_key, watch_users: current_chat_room.watch_users)
    end

    room_members_update
  end

  def battle_start(data)
    current_chat_room.update!(begin_at: Time.current)
    ActionCable.server.broadcast(room_key, {
        begin_at: current_chat_room.begin_at,
        human_kifu_text: current_chat_room.human_kifu_text, # 開始日時が埋められた棋譜で更新したいため
      })
  end

  def time_up_trigger(data)
    # membership_ids は送ってきた人で対応するレコードにタイムアップ認定する
    chat_memberships = current_chat_room.chat_memberships.where(id: data["membership_ids"])
    chat_memberships.each do |e|
      e.update!(time_up_trigger_at: Time.current)
    end

    # メンバー是認がタイムアップ認定したら全員にタイムアップ通知する
    # こうすることで1秒残してタイムアップにならなくなる
    if current_chat_room.chat_memberships.where.not(time_up_trigger_at: nil).count >= current_chat_room.chat_memberships.count
      current_chat_room.update!(end_at: Time.current, win_location_key: data["win_location_key"], last_action_key: "TIME_UP")
      game_end_broadcast
    end
  end

  # 負ける人が申告する
  def give_up_trigger(data)
    current_chat_room.update!(end_at: Time.current, win_location_key: data["win_location_key"], last_action_key: "TORYO")
    game_end_broadcast
  end

  # 先後をまとめて反転する
  def location_flip_all(data)
    current_chat_room.chat_memberships.each(&:location_flip!)
    room_members_update
  end

  def game_end_broadcast
    ActionCable.server.broadcast(room_key, {
        end_at: current_chat_room.end_at,
        win_location_key: current_chat_room.win_location_key,
        last_action_key: current_chat_room.last_action_key,
        human_kifu_text: current_chat_room.human_kifu_text, # end_at が埋めこまれた棋譜で更新しておくため
      })
  end

  # 先後をまとめて反転する
  def countdown_mode_on(data)
    location = Warabi::Location.fetch(data["location_key"])
    current_chat_room.countdown_mode_hash[location.key] = true
    current_chat_room.save!
  end

  private

  def room_members_update
    # model の中から行う
    # 部屋を抜けたときの状態が反映されるように reload が必要
    # FIXME: 1件だけ行う
    ActionCable.server.broadcast(room_key, room_members: ams_sr(current_chat_room.reload.chat_memberships))
  end

  def room_key
    "chat_room_channel_#{params[:chat_room_id]}"
  end

  def current_chat_room
    @current_chat_room ||= ChatRoom.find(params[:chat_room_id])
  end

  # 自分対自分の場合もあるためメンバー情報は複数ある
  def current_chat_memberships
    @current_chat_memberships ||= current_chat_room.chat_memberships.where(chat_user: current_chat_user)
  end
end
