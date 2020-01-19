module Colosseum
  class ApplicationController < ::ApplicationController
    # before_action :authenticate_action
    #
    # def authenticate_action
    #   if !current_user
    #     authenticate_xuser!
    #   end
    # end

    def js_global
      @js_global ||= super.merge({
          :current_user => current_user && ams_sr(current_user, serializer: Colosseum::CurrentUserSerializer),
          :login_path   => url_for([:xuser_session, __redirect_to: url_for(:xuser_session), __flash: {alert: "アカウント登録もしくはログインしてください。すぐに遊びたい場合は「名無しのアカウントを作成してログイン」を使ってみてください。"}]),

          :custom_session_id        => custom_session_id, # CPU対戦で対局者を特定するため(こうしなくてもセッションで httponly: false にすると document.cookie から取れるらしいが危険)
          :chat_display_lines_limit => Colosseum::LobbyMessage.chat_display_lines_limit,

          :lifetime_infos           => Colosseum::LifetimeInfo,
          :team_infos               => Colosseum::TeamInfo,
          :custom_preset_infos      => Colosseum::CustomPresetInfo,
          :robot_accept_infos       => Colosseum::RobotAcceptInfo,
          :last_action_infos        => Colosseum::LastActionInfo,

          :joined_only_count        => Colosseum::User.joined_only.count,
          :fighter_only_count       => Colosseum::User.fighter_only.count,
        })
    end
  end
end
