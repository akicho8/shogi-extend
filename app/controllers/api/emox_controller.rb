# 将棋トレーニングバトル
#
# entry
#   app/controllers/api/emox_controller.rb
#
# vue
#   app/javascript/emox_app/index.vue
#
# db
#   db/migrate/20200505135600_create_emox.rb
#
# test
#   experiment/0860_emox.rb
#
# model
#   app/models/emox/membership.rb
#   app/models/emox/battle.rb
#   app/models/emox.rb
#   app/models/colosseum/user_emox_mod.rb
#
#   question
#     app/models/emox/question.rb
#     app/models/emox/moves_answer.rb
#
# channel
#   app/channels/emox/lobby_channel.rb
#   app/channels/emox/battle_channel.rb
#
# job
#   app/jobs/emox/lobby_broadcast_job.rb
#   app/jobs/emox/message_broadcast_job.rb
#

module Api
  class EmoxController < ::Api::ApplicationController
    def current_battle_id
      params[:battle_id].presence
    end

    def current_battle
      if v = current_battle_id
        Emox::Battle.find_by(id: v)
      end
    end

    def users
      [current_user, User.bot]
    end

    # http://localhost:3000/api/emox/resource_fetch.json
    def resource_fetch
      if current_user
        current_user_set_for_action_cable(current_user)
      end

      render json: {
        :mode         => "lobby",
        :current_user => current_user&.as_json_type20x,
        :config       => Emox::Config,
        :RuleInfo     => Emox::RuleInfo.as_json,
        :EmotionInfo  => Emox::EmotionInfo.as_json,
      }
    end

    # 更新することでマッチング結果はこちらが対象になる
    # curl -d _method=put -d _user_id=1 -d remote_action=session_lock_token_set_handle -d session_lock_token=xxx http://localhost:3000/api/emox.json
    def session_lock_token_set_handle
      raise ArgumentError, params.inspect if params[:session_lock_token].blank?
      # if current_user.emox_setting.session_lock_token
      #   return { error_message: "" }
      # end
      current_user.create_emox_setting_if_blank
      current_user.emox_setting.update!(session_lock_token: params[:session_lock_token])
      render json: { status: "success" }
    end

    # curl -d _method=put -d _user_id=1 -d remote_action=session_lock_token_valid_handle -d session_lock_token=xxx http://localhost:3000/api/emox.json
    def session_lock_token_valid_handle
      raise ArgumentError, params.inspect if params[:session_lock_token].blank?
      if current_user.session_lock_token_valid?(params[:session_lock_token])
        render json: { status: "success" }
      else
        render json: { status: "session_lock_token_invalid" }
      end
    end

    # curl -d _method=put -d _user_id=1 -d remote_action=session_lock_token_reset_handle http://localhost:3000/api/emox.json
    # def session_lock_token_reset_handle
    #   current_user.emox_setting.update!(session_lock_token: nil)
    #   { status: "success" }
    # end

    # curl -d _method=put -d _user_id=1 -d remote_action=rule_key_set_handle -d rule_key=sy_marathon http://localhost:3000/api/emox.json
    def rule_key_set_handle
      raise ArgumentError, params.inspect if params[:session_lock_token].blank?
      unless current_user.session_lock_token_valid?(params[:session_lock_token])
        render json: { status: "session_lock_token_invalid" }
        return
      end
      current_user.emox_setting.update!(rule: Emox::Rule.fetch(params[:rule_key]))
      render json: { status: "success" }
    end

    # 自分以外の誰かを指定ルールに参加させる
    def debug_matching_add_handle
      if user = User.where.not(id: params[:exclude_user_id]).first
        Emox::Rule.matching_users_delete_from_all_rules(user)
        if rule_key = params[:rule_key]
          rule = Emox::Rule.fetch(rule_key)
          user.emox_setting.update!(rule: rule)
        else
          rule = current_user.emox_setting.rule
        end
        rule.matching_users_add(user)
      end
      render json: { status: "success" }
    end

    # 解散
    def matching_users_clear_handle
      Emox::Rule.matching_users_clear
      render json: { status: "success" }
    end
  end
end
