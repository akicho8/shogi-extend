module Emox
  class BattleChannel < BaseChannel
    include BattleChannelVersusMethods

    def subscribed
      return reject unless current_user
      raise ArgumentError, params.inspect unless battle_id

      stream_from "emox/battle_channel/#{battle_id}"
    end

    # バトルが正常終了していない状態で切断された場合に負け
    def unsubscribed
      if current_battle.end_at.blank?
        if once_run("emox/battles/#{current_battle.id}/disconnect")
          judge_final_set(current_user, :lose, :f_disconnect)
        end
      end
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
      # --> app/javascript/emox_app/application.vue
    end

    # membership_id が切断した風にする(デバッグ用)
    # 切断すると即負けになる
    def member_disconnect_handle(data)
      data = data.to_options
      membership = current_battle.memberships.find(data[:membership_id])
      raise "もう終わっている" if current_battle.end_at?
      judge_final_set(membership.user, :lose, :f_disconnect)
    end

    private

    ################################################################################

    def broadcast(bc_action, bc_params)
      if bc_params.values.any? { |e| e.nil? }
        raise ArgumentError, bc_params.inspect
      end
      ActionCable.server.broadcast("emox/battle_channel/#{battle_id}", {bc_action: bc_action, bc_params: bc_params})
    end

    def battle_id
      params["battle_id"]
    end

    def current_battle
      Battle.find(battle_id)
    end

    def current_rule_info
      current_battle.room.rule.pure_info
    end
  end
end
