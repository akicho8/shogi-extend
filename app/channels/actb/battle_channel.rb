module Actb
  class BattleChannel < BaseChannel
    def subscribed
      raise ArgumentError, params.inspect unless battle_id

      stream_from "actb/battle_channel/#{battle_id}"
    end

    def unsubscribed
      if current_battle.end_at.blank?
        katimashita(current_user, :lose, :f_disconnect)
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
          katimashita(current_user, :win, :f_success)
        end
        if command == "lose"
          katimashita(current_user, :lose, :f_disconnect)
        end
      end
    end

    def start_hook(data)
      history_update(data, :mistake)
    end

    def g2_hayaosi_handle(data)
      data = data.to_options
      # membership_id: this.current_membership.id,
      # question_id: this.current_question_id,

      # this.silent_remote_fetch("PUT", this.app.info.put_path, { g2_hayaosi_handle: true, battle_id: this.app.battle.id, membership_id: this.app.current_membership.id, question_id: this.app.current_best_question.id }, e => {
      # { g2_hayaosi_handle: true, battle_id: membership_id: this.current_membership.id, question_id: this.current_best_question.id }

      key = [:early_press, current_battle, data[:question_id]].join("/")
      Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, key])
      early_press_counter = redis.incr(key)
      redis.expire(key, 60)
      if early_press_counter === 1
        g2_hayaosi_handle_broadcasted = {
          membership_id: data[:membership_id],
          question_id: data[:question_id],
          early_press_counter: early_press_counter,
        }
        ActionCable.server.broadcast("actb/battle_channel/#{battle_id}", { bc_action: :g2_hayaosi_handle_broadcasted, bc_params: g2_hayaosi_handle_broadcasted })
      end
    end

    def g2_jikangire_handle(data)
      data = data.to_options

      key = [:early_press, current_battle, data[:question_id]].join("/")
      redis.del(key)

      g2_jikangire_handle_broadcasted = {
        membership_id: data[:membership_id],
        question_id: data[:question_id],
      }
      ActionCable.server.broadcast("actb/battle_channel/#{battle_id}", { bc_action: :g2_jikangire_handle_broadcasted, bc_params: g2_jikangire_handle_broadcasted })
    end

    def kotae_sentaku(data)
      data = data.to_options

      history_update(data, data[:ox_mark_key])

      bc_params = {
        membership_id:  data[:membership_id],  # 誰が
        question_index: data[:question_index], # どこまで進めたか
        question_id:    data[:question_id],    # これいらんけど、そのまま渡しとく
        ox_mark_key:    data[:ox_mark_key],
      }

      # 一応保存しておく(あとで取るかもしれない)
      # current_battle.memberships.find(data[:membership_id]).update!(question_index: data[:question_index])

      # 問題の解答数を上げる
      if data[:ox_mark_key] == "correct"
        Question.find(data[:question_id]).increment!(:o_count)
      else
        Question.find(data[:question_id]).increment!(:x_count)
      end

      # こちらがメイン
      ActionCable.server.broadcast("actb/battle_channel/#{battle_id}", { bc_action: :kotae_sentaku_broadcasted, bc_params: bc_params })
    end

    # 次に進む
    def next_trigger(data)
      history_update(data, :mistake)

      data = data.to_options
      bc_params = {
        membership_id:  data[:membership_id],
        question_index: data[:question_index],
        question_id:    data[:question_id],
      }
      ActionCable.server.broadcast("actb/battle_channel/#{battle_id}", { bc_action: :next_trigger_broadcasted, bc_params: bc_params })
    end

    # 盤面を共有する
    def kyouyuu(data)
      data = data.to_options
      bc_params = {
        share_sfen: data[:share_sfen],
      }
      ActionCable.server.broadcast("actb/battle_channel/#{battle_id}", { bc_action: :kyouyuu_broadcasted, bc_params: bc_params })
    end

    # <-- app/javascript/actb_app/application.vue
    def goal_hook(data)
      katimashita(current_user, :win, :f_success)
    end

    def katimashita(target_user, judge_key, final_key)
      battle = current_battle

      if battle.end_at?
        Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, "すでに終了している"])
        return
      end

      battle.katimashita(target_user, judge_key, final_key)
      battle.reload

      ActionCable.server.broadcast("actb/battle_channel/#{battle_id}", { bc_action: "katimashita_broadcasted", bc_params: { battle: battle.as_json_type2 }})
      # --> app/javascript/actb_app/application.vue
    end

    # 再戦
    def battle_continue_handle(data)
      data = data.to_options
      bc_params = {
        membership_id: data[:membership_id],
      }

      key = [:battle_continue_handle, current_battle.id].join("/") # key = "battle_continue_handle/1"
      redis.hincrby(key, data[:membership_id], 1)       # counts[membership_id] += 1
      redis.expire(key, 1.days)                         # 指定秒数後に破棄
      counts = redis.hgetall(key)                       # => {"1" => "2"}
      counts = counts.transform_keys(&:to_i)
      counts = counts.transform_values(&:to_i)
      counts                                            # => {1 => 2}

      # キーが2つかつ、どちらかのカウンタが1回目のときだけ、とすれば連打されても何個も部屋は生成されなくなる
      if counts.count == current_battle.users.count
        # {10 => 5, 11 => 1} なら発動して {10 => 5, 11 => 2} なら発動しない
        if counts.values.any? { |e| e == 1 }
          current_battle.onaji_heya_wo_atarasiku_tukuruyo
        end
        return
      end

      bc_params = {
        membership_id: data[:membership_id],
        battle_continue_tap_counts: counts,
      }

      # Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, methods.grep(/broadcast/)])

      ActionCable.server.broadcast("actb/battle_channel/#{battle_id}", { bc_action: :battle_continue_handle_broadcasted, bc_params: bc_params })
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

      b_scores = current_battle.memberships.collect { |e| data[:member_infos_hash][e.id.to_s]["b_score"] }
      if b_scores.max < Actb::Config[:b_score_max_for_win]
        katimashita(nil, :draw, :f_draw)
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

      katimashita(membership.user, :win, :f_success)
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
      history = current_user.actb_histories.find_or_initialize_by(membership: membership, question: question)
      history.update!(ox_mark: Actb::OxMark.fetch(ox_mark))
    end
  end
end
