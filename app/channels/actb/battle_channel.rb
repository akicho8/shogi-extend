module Actb
  class BattleChannel < BaseChannel
    include BattleChannelVersusMod

    def subscribed
      __event_notify__(__method__, battle_id: battle_id)
      return reject unless current_user
      raise ArgumentError, params.inspect unless battle_id

      stream_from "actb/battle_channel/#{battle_id}"
    end

    # バトルが正常終了していない状態で切断された場合に負け
    def unsubscribed
      __event_notify__(__method__, battle_id: battle_id)
      if current_battle.end_at.blank?
        if once_run("actb/battles/#{current_battle.id}/disconnect")
          say "*切断しました"
          judge_final_set(current_user, :lose, :f_disconnect)
        end
      end
    end

    def speak(data)
      data = data.to_options
      if data[:message_body].start_with?("/")
        execution_interrupt_hidden_command(data[:message_body])
      else
        current_user.actb_room_messages.create!(body: data[:message_body], room: current_battle.room)
      end
    end

    def execution_interrupt_hidden_command(str)
      # if message_body = battle.messages.where(user: current_user).order(created_at: :desc).first
      if md = str.to_s.match(/\/(?<command_line>.*)/)
        args = md["command_line"].split
        command = args.shift
        if command == "win"
          judge_final_set(current_user, :win, :f_success)
        end
        if command == "lose"
          judge_final_set(current_user, :lose, :f_disconnect)
        end
      end
    end

    # 最初の問題のときだけ
    def start_hook(data)
      # history_set_by_data(data, :mistake)
    end

    # 「わかった」
    # 両者から呼ばれる
    # 先に押した方だけ解答権を得る
    def answer_button_push_handle(data)
      data = data.to_options
      if once_run(answer_button_push_key(data), expires_in: 1.minute)
        broadcast(:answer_button_push_handle_broadcasted, data)
      end
    end

    # 「わかった」のあと操作中に時間切れ
    # 解答権のある方からのみ呼ばれる
    # 再び「わかった」できるようにする
    def x2_play_timeout_handle(data)
      data = data.to_options
      redis.del(answer_button_push_key(data))
      broadcast(:x2_play_timeout_handle_broadcasted, data)
    end

    # 答え選択
    def kotae_sentaku(data)
      data = data.to_options

      question = Question.find(data[:question_id])                          # 問題
      ox_mark = Actb::OxMark.fetch(data[:ox_mark_key])                      # 結果
      my_membership = current_battle.memberships.find(data[:membership_id]) # 当事者
      op_membership = (current_battle.memberships - [my_membership]).first  # 相手
      my_user = my_membership.user
      op_user = op_membership.user

      # mistake は来ない
      raise ArgumentError, data.inspect if ox_mark.key == "mistake"

      # 基本個人プレイで同期してない
      if current_strategy_key == :sy_marathon
        raise ArgumentError, data.inspect unless my_membership.user == current_user
        history_create(my_user, question, ox_mark)
        question.ox_add(ox_mark.pure_info.question_counter_column)
      end

      # 正解時         → 正解したユーザーが送信者
      # タイムアウト時 → 両方が送信者
      if current_strategy_key == :sy_singleton || current_strategy_key == :sy_hybrid
        if ox_mark.key == "correct"
          history_create(my_user, question, ox_mark)
          history_create(op_user, question, :mistake)
          question.ox_add(:o_count) # 片方が正解なら1回分の正解として、もう片方の不正解はカウントしない
        end
        if ox_mark.key == "timeout"
          # 両者が送信者なので最初だけ実行
          if already_run?([:kotae_sentaku, already_run_key, data[:question_id]], expires_in: 1.minute)
            debug_say "**skip kotae_sentaku"
            return
          end
          current_battle.users.each do |user|
            history_create(user, question, ox_mark)
          end
          question.ox_add(:x_count) # 2人分時間切れしたとき1回分の不正解とする
        end
      end

      broadcast(:kotae_sentaku_broadcasted, data)
    end

    # 次に進む
    def next_trigger(data)
      data = data.to_options

      if current_strategy_key == :sy_marathon
        broadcast(:next_trigger_broadcasted, data)
      end

      if current_strategy_key == :sy_singleton || current_strategy_key == :sy_hybrid
        key = [:next_trigger, already_run_key, data[:question_id]]
        if once_run(key, expires_in: 1.minute)
          broadcast(:next_trigger_broadcasted, data)
        end
      end
    end

    # 盤面を共有する
    def play_board_share(data)
      data = data.to_options
      broadcast(:play_board_share_broadcasted, data)
    end

    # <-- app/javascript/actb_app/application.vue
    def goal_hook(data)
      judge_final_set(current_user, :win, :f_success)
    end

    def judge_final_set(target_user, judge_key, final_key)
      battle = current_battle

      if battle.end_at?
        Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, "すでに終了している"])
        return
      end

      # 練習の場合は勝ち負けを更新しない
      if battle.room.bot_user
        battle.update!(end_at: Time.current)
      else
        battle.judge_final_set(target_user, judge_key, final_key)
      end

      battle.reload
      broadcast(:judge_final_set_broadcasted, battle: battle.as_json_type2_for_result)
      # --> app/javascript/actb_app/application.vue
    end

    # 再戦希望
    def battle_continue_handle(data)
      data = data.to_options

      counts = counter_increment(data[:membership_id])

      # 両者が押した(キーが2つ)かつ、どちらかのカウンタが1回目のときだけ、とすれば連打されても何個も部屋は生成されなくなる
      if counts.count == current_battle.users.count
        # {10 => 5, 11 => 1} なら発動して {10 => 5, 11 => 2} なら発動しない
        if counts.values.any? { |e| e == 1 }
          __event_notify__("再戦開始")
          current_battle.battle_chain_create
        end
        return
      end

      data = data.merge(continue_tap_counts: counts)
      broadcast(:battle_continue_handle_broadcasted, data)
    end

    # 強制続行
    def battle_continue_force_handle(data)
      __event_notify__("強制続行")
      current_battle.battle_chain_create
    end

    # data["member_infos_hash"] = {
    #   "15" => {"ox_list"=>["correct"], "b_score"=>1},
    #   "16" => {"ox_list"=>[],          "b_score"=>0},
    # }
    def judgement_run(data)
      data = data.to_options

      if current_strategy_key == :sy_singleton || current_strategy_key == :sy_hybrid
        # 2回目の実行はキャンセル
        if already_run?([:judgement_run, already_run_key], expires_in: 1.minute)
          debug_say "**skip judgement_run"
          return
        end
      end

      # 両方5点とってなければ引き分け
      b_scores = current_battle.memberships.collect { |e| data[:member_infos_hash][e.id.to_s]["b_score"] }
      if b_scores.max < current_rule_info.b_score_max_for_win
        judge_final_set(nil, :draw, :f_draw)
        return
      end

      membership = current_battle.memberships.sort_by { |e|
        [
          -data[:member_infos_hash][e.id.to_s]["b_score"],      # 1. スコア高い方
          # -data[:member_infos_hash][e.id.to_s]["ox_list"].size, # 2. たくさん答えた方
          e.user.created_at,                                    # 3. 早く会員になった方
          e.user.id,
        ]
      }.first

      judge_final_set(membership.user, :win, :f_success)
    end

    # membership_id が切断した風にする(デバッグ用)
    # 切断すると即負けになる
    def member_disconnect_handle(data)
      data = data.to_options
      membership = current_battle.memberships.find(data[:membership_id])
      raise "もう終わっている" if current_battle.end_at?
      judge_final_set(membership.user, :lose, :f_disconnect)
    end

    # 退出通知
    # data[:membership_id] が退出する
    def battle_leave_handle(data)
      data = data.to_options
      broadcast(:battle_leave_handle_broadcasted, data)
    end

    private

    def history_create(user, question, ox_mark)
      if current_battle.room.bot_user == user
        # 練習モードのBOTなら履歴は作らない
      else
        user.actb_histories.create!(question: question, ox_mark: OxMark.fetch(ox_mark), room: current_battle.room)
      end
    end

    ################################################################################

    def broadcast(bc_action, bc_params)
      if bc_params.values.any? { |e| e.nil? }
        raise ArgumentError, bc_params.inspect
      end
      ActionCable.server.broadcast("actb/battle_channel/#{battle_id}", {bc_action: bc_action, bc_params: bc_params})
    end

    def answer_button_push_key(data)
      [:answer_button_push, current_battle.id, data[:question_id]].join("/")
    end

    # counts[membership_id] += 1
    def counter_increment(membership_id)
      key = [:battle_continue_handle, current_battle.id].join("/")

      # https://qiita.com/shiozaki/items/b746dc4bb5e1e87c0528
      values = redis.multi do
        redis.hincrby(key, membership_id, 1)
        redis.expire(key, 1.days)
        redis.hgetall(key)      # => {"1" => "2"}
      end
      counts = values.last
      counts.transform_keys(&:to_i).transform_values(&:to_i)
    end

    def say(*args)
      return if Rails.env.test?
      current_user.room_speak(current_battle.room, *args)
    end

    def debug_say(*args)
      if Config[:action_cable_debug]
        say(*args)
      end
    end

    def battle_id
      params["battle_id"]
    end

    def current_battle
      Battle.find(battle_id)
    end

    def already_run_key
      current_battle.id
    end

    def current_strategy_key
      current_rule_info.strategy_key
    end

    def current_rule_info
      current_battle.room.rule.pure_info
    end
  end
end
