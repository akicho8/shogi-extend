module Actb
  class BattleChannel < BaseChannel
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

    def start_hook(data)
      history_update(data, :mistake)
    end

    def wakatta_handle(data)
      data = data.to_options
      key = early_press_key(data)
      early_press_counter = redis.incr(key)
      redis.expire(key, 60)
      if early_press_counter === 1
        bc_params = {
          :membership_id => data[:membership_id],
          :question_id   => data[:question_id],
        }
        broadcast(:wakatta_handle_broadcasted, bc_params)
      end
    end

    def x2_play_timeout_handle(data)
      data = data.to_options
      redis.del(early_press_key(data))
      bc_params = {
        :membership_id => data[:membership_id],
        :question_id   => data[:question_id],
      }
      broadcast(:x2_play_timeout_handle_broadcasted, bc_params)
    end

    def kotae_sentaku(data)
      data = data.to_options
      ox_mark = Actb::OxMark.fetch(data[:ox_mark_key])
      question = Question.find(data[:question_id])
      my_membership = current_battle.memberships.find(data[:membership_id]) # 当事者
      op_membership = (current_battle.memberships - [my_membership]).first    # 対戦相手

      # 基本個人プレイで同期してない
      if current_battle.rule.key == "marathon_rule"
        raise ArgumentError, data.inspect if ox_mark.key == "mistake"
        raise ArgumentError, data.inspect unless my_membership.user == current_user
        current_user.actb_histories.find_or_initialize_by(question: question, membership: my_membership).update!(ox_mark: ox_mark)
        question.ox_add(ox_mark.pure_info.question_counter_column)
      end

      # 正解時         → 正解したユーザーが送信者
      # タイムアウト時 → 両方が送信者
      if current_battle.rule.key == "singleton_rule" || current_battle.rule.key == "hybrid_rule"
        raise ArgumentError, data.inspect if ox_mark.key == "mistake"
        if ox_mark.key == "correct"
          my_membership.user.actb_histories.find_or_initialize_by(membership: my_membership, question: question).update!(ox_mark: ox_mark)
          op_membership.user.actb_histories.find_or_initialize_by(membership: op_membership, question: question).update!(ox_mark: Actb::OxMark.fetch(:mistake))
          question.ox_add(:o_count) # 片方が正解なら1回分の正解として、もう片方の不正解はカウントしない
        end
        if ox_mark.key == "timeout"
          # 両者が送信者なので最初だけ実行
          if already_run?([:kotae_sentaku, room_battle_keys, data[:question_id]], expires_in: 1.minute)
            debug_say "**skip kotae_sentaku"
            return
          end
          current_battle.memberships.each do |membership|
            membership.user.actb_histories.find_or_initialize_by(question: question, membership: membership).update!(ox_mark: ox_mark)
          end
          question.ox_add(:x_count) # 2人分時間切れしたとき1回分の不正解とする
        end
      end

      bc_params = {
        membership_id:  data[:membership_id],  # 誰が
        question_index: data[:question_index], # どこまで進めたか
        question_id:    data[:question_id],    # これいらんけど、そのまま渡しとく
        ox_mark_key:    data[:ox_mark_key],
      }

      # 一応保存しておく(あとで取るかもしれない)
      # current_battle.memberships.find(data[:membership_id]).update!(question_index: data[:question_index])

      # # 問題の解答数を上げる
      # if data[:ox_mark_key] == "correct"
      #   Question.find(data[:question_id]).increment!(:o_count)
      # else
      #   Question.find(data[:question_id]).increment!(:x_count)
      # end

      broadcast(:kotae_sentaku_broadcasted, bc_params)
    end

    # 次に進む
    def next_trigger(data)
      data = data.to_options

      # 本人が送信しているので本人だけの履歴を作成
      if current_battle.rule.key == "marathon_rule"
        history_update(data, :mistake)
      end

      # リーダーが送信者なので対局者の両方にあらかじめ履歴を作っておく
      if current_battle.rule.key == "singleton_rule" || current_battle.rule.key == "hybrid_rule"
        if already_run?([:next_trigger, room_battle_keys, data[:question_id]], expires_in: 1.minute)
          debug_say "**skip next_trigger"
          return
        end
        question = Question.find(data[:question_id])
        current_battle.memberships.each do |membership|
          membership.user.actb_histories.find_or_initialize_by(question: question, membership: membership).update!(ox_mark: OxMark.fetch(:mistake))
        end
      end

      bc_params = {
        membership_id:  data[:membership_id],
        question_index: data[:question_index],
        question_id:    data[:question_id],
      }
      broadcast(:next_trigger_broadcasted, bc_params)
    end

    # 盤面を共有する
    def play_board_share(data)
      data = data.to_options
      bc_params = {
        membership_id: data[:membership_id],
        share_sfen: data[:share_sfen],
      }
      broadcast(:play_board_share_broadcasted, bc_params)
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

      battle.judge_final_set(target_user, judge_key, final_key)
      battle.reload

      broadcast(:judge_final_set_broadcasted, battle: battle.as_json_type2_for_result)
      # --> app/javascript/actb_app/application.vue
    end

    # 再戦希望
    def battle_continue_handle(data)
      data = data.to_options
      bc_params = {
        membership_id: data[:membership_id],
      }

      counts = counter_increment(data[:membership_id])

      # 両者が押した(キーが2つ)かつ、どちらかのカウンタが1回目のときだけ、とすれば連打されても何個も部屋は生成されなくなる
      if counts.count == current_battle.users.count
        # {10 => 5, 11 => 1} なら発動して {10 => 5, 11 => 2} なら発動しない
        if counts.values.any? { |e| e == 1 }
          current_battle.onaji_heya_wo_atarasiku_tukuruyo
        end
        return
      end

      bc_params = {
        membership_id: data[:membership_id],
        continue_tap_counts: counts,
      }
      broadcast(:battle_continue_handle_broadcasted, bc_params)
    end

    # 強制続行
    def battle_continue_force_handle(data)
      current_battle.onaji_heya_wo_atarasiku_tukuruyo
    end

    # data["member_infos_hash"] = {
    #   "15" => {"ox_list"=>["correct"], "b_score"=>1},
    #   "16" => {"ox_list"=>[],          "b_score"=>0},
    # }
    def owattayo(data)
      data = data.to_options

      if current_battle.rule.key == "singleton_rule" || current_battle.rule.key == "hybrid_rule"
        # 2回目の実行はキャンセル
        if already_run?([:owattayo, room_battle_keys], expires_in: 1.minute)
          debug_say "**skip owattayo"
          return
        end
      end

      # 両方5点とってなければ引き分け
      b_scores = current_battle.memberships.collect { |e| data[:member_infos_hash][e.id.to_s]["b_score"] }
      if b_scores.max < Actb::Config[:b_score_max_for_win]
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

      # 単に発言させるためだけ
      if Config[:action_cable_debug]
        membership = Actb::BattleMembership.find(data[:membership_id])
        membership.room_speak("*退室します")
      end

      broadcast(:battle_leave_handle_broadcasted, membership_id: data[:membership_id])
    end

    def battle_id
      params["battle_id"]
    end

    def current_battle
      Battle.find(battle_id)
    end

    def history_update(data, ox_mark)
      data = data.to_options
      question = Question.find(data[:question_id])
      membership = current_battle.memberships.find(data[:membership_id])
      history = current_user.actb_histories.find_or_initialize_by(question: question, membership: membership)
      history.update!(ox_mark: Actb::OxMark.fetch(ox_mark))
    end

    def broadcast(bc_action, bc_params)
      raise ArgumentError, bc_params.inspect unless bc_params.values.all?
      ActionCable.server.broadcast("actb/battle_channel/#{battle_id}", {bc_action: bc_action, bc_params: bc_params})
    end

    def early_press_key(data)
      [:early_press, current_battle.id, data[:question_id]].join("/")
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

    def room_battle_keys
      [current_battle.room.id, current_battle.id]
    end
  end
end
