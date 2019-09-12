class ApplicationController < ActionController::Base
  before_action do
    ActiveStorage::Current.host = request.base_url
  end

  before_action do
    request.env["exception_notifier.exception_data"] = {
      current_user: current_user,
    }
  end

  # http://localhost:3000/?force_error=1
  # http://tk2-221-20341.vs.sakura.ne.jp/shogi?force_error=1
  prepend_before_action do
    if params[:force_error]
      1 / 0
    end
  end

  before_action do
    if params[:__redirect_to]
      redirect_to params[:__redirect_to], params.permit![:__flash]
    end
  end

  concerning :ActiveModelSerializerMethods do
    included do
      # 効かないのはなぜ……？
      #
      # ▼active_model_serializers/serializers.md at v0.10.6 · rails-api/active_model_serializers
      # https://github.com/rails-api/active_model_serializers/blob/v0.10.6/docs/general/serializers.md
      #
      # serialization_scope :view_context
    end
  end

  concerning :ChoreMethods do
    included do
      add_flash_types *FlashInfo.flash_all_keys
      helper_method :submitted?
      helper_method :iframe?
    end

    def submitted?(name)
      params.key?(name)
    end

    def slack_message(**params)
      SlackAgent.message_send(params.merge(ua: ua))
    end

    def iframe?
      !!params[:iframe]
    end

    private

    def h
      @h ||= view_context
    end
    delegate :tag, :link_to, :fa_icon_tag, :icon_tag, :auto_link, to: :h
  end

  concerning :CurrentUserMethods do
    included do
      helper_method :js_global
      helper_method :sysop?
      helper_method :editable_record?
      helper_method :current_user
    end

    let :js_global do
      {
        :current_user        => current_user && ams_sr(current_user, serializer: Colosseum::CurrentUserSerializer),
        :online_only_count   => Colosseum::User.online_only.count,
        :fighter_only_count  => Colosseum::User.fighter_only.count,
        :lifetime_infos      => Colosseum::LifetimeInfo,
        :team_infos          => Colosseum::TeamInfo,
        :custom_preset_infos => Colosseum::CustomPresetInfo,
        :robot_accept_infos  => Colosseum::RobotAcceptInfo,
        :last_action_infos   => Colosseum::LastActionInfo,
        :login_path          => url_for([:xuser_session, __redirect_to: url_for(:xuser_session), __flash: {alert: "アカウント登録もしくはログインしてください。すぐに遊びたい場合は「名無しのアカウントを作成してログイン」を使ってみてください。"}]),
        :talk_path           => talk_path,
        :custom_session_id   => custom_session_id, # CPU対戦で対局者を特定するため(こうしなくてもセッションで httponly: false にすると document.cookie から取れるらしいが危険)
        :chat_display_lines_limit => Colosseum::LobbyMessage.chat_display_lines_limit,
      }
    end

    let :sysop? do
      current_user && current_user.sysop?
    end

    def editable_record?(record)
      sysop? || current_user_is_owner_of?(record)
    end

    def current_user_is_owner_of?(record)
      if current_user
        if record
          if record.respond_to?(:owner_user)
            if record.owner_user
              record.owner_user == current_user
            end
          end
        end
      end
    end

    let :current_user do
      # # unless bot_agent?       # ブロックの中なので guard return してはいけない
      # user_id = nil
      # # unless Rails.env.production?
      # #   user_id ||= params[:__user_id__]
      # # end
      # user_id ||=

      user = nil
      if id = cookies.signed[:user_id]
        user ||= Colosseum::User.find_by(id: id)
      end
      user ||= current_xuser

      if Rails.env.test?
        if params[:__create_user_name__]
          user ||= Colosseum::User.create!(name: params[:__create_user_name__], user_agent: request.user_agent)
          user.appear
        end
      end

      if user
        cookies.signed[:user_id] = {value: user.id, expires: 1.years.from_now}
      end

      user
      # end
    end

    def current_user_set_id(user_id)
      if instance_variable_defined?(:@current_user)
        remove_instance_variable(:@current_user)
      end
      if user_id
        cookies.signed[:user_id] = {value: user_id, expires: 1.years.from_now}
      else
        cookies.delete(:user_id)
      end
    end

    def current_user_logout
      current_user_set_id(nil)
      sign_out(:xuser)
    end
  end

  concerning :TalkMethods do
    included do
      helper_method :talk
    end

    let :custom_session_id do
      Digest::MD5.hexdigest(session.id || SecureRandom.hex) # Rails.env.test? のとき session.id がないんだが
    end

    # talk("こんにちは")
    #
    # 実行順序
    #
    #   light_session_channel.rb
    #     light_session_app.js
    #       vue_support.js (talk)
    #         axios
    #           talk_controller.rb
    #         Audio#play
    #
    # ショートカットする方法
    #
    #   ActionCable.server.broadcast("light_session_channel_#{custom_session_id}", talk: Talk.new(source_text: "こんにちは").as_json)
    #
    def talk(str)
      str.tap do
        ActionCable.server.broadcast("light_session_channel_#{custom_session_id}", yomiage: str)
      end
    end

    def direct_talk(str)
      str.tap do
        ActionCable.server.broadcast("light_session_channel_#{custom_session_id}", talk: Talk.new(source_text: str))
      end
    end
  end

  concerning :BotCheckMethods do
    included do
      helper_method :ua
    end

    let :ua do
      @ua ||= UserAgent.parse(request.user_agent.to_s)
    end

    let :bot_agent? do
      ua.bot?
    end
  end

  concerning :MobileMethods do
    included do
      helper_method :mobile_agent?
    end

    let :mobile_agent? do
      ua.mobile?
    end
  end

  concerning :ShowiPlayerMethods do
    included do
      helper_method :sp_theme_default
    end

    let :sp_theme_default do
      # if mobile_agent?
      #   "simple"
      # else
      #   "real"
      # end
      "simple"
    end
  end
end
