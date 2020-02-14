class ApplicationController < ActionController::Base
  include LightSessionMethods

  before_action do
    ActiveStorage::Current.host = request.base_url
  end

  before_action do
    request.env["exception_notifier.exception_data"] = {
      current_user_id: current_user&.id,
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
      add_flash_types *FlashInfo.all_keys
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
      helper_method :login_display?
    end

    def js_global
      @js_global ||= {
        :current_user => current_user && ams_sr(current_user, serializer: Colosseum::BasicUserSerializer),
        :talk_path    => talk_path,
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
      id = session[:user_id]
      if AppConfig[:colosseum_battle_enable]
        id ||= cookies.signed[:user_id]
      end
      if id
        user ||= Colosseum::User.find_by(id: id)
      end
      user ||= current_xuser

      if Rails.env.test?
        if params[:__create_user_name__]
          user ||= Colosseum::User.create!(name: params[:__create_user_name__], user_agent: request.user_agent)
          user.lobby_in_handle
          cookies.signed[:user_id] = {value: user.id, expires: 1.years.from_now}
        end
      end

      # if user
      #   cookies.signed[:user_id] = {value: user.id, expires: 1.years.from_now}
      # end

      user
      # end
    end

    def current_user_set_id(user_id)
      if instance_variable_defined?(:@current_user)
        remove_instance_variable(:@current_user)
      end

      if user_id
        session[:user_id] = user_id
      else
        session.delete(:user_id)
      end

      if AppConfig[:colosseum_battle_enable]
        if user_id
          cookies.signed[:user_id] = {value: user_id, expires: 1.years.from_now}
        else
          cookies.delete(:user_id)
        end
      end
    end

    def current_user_logout
      if current_user
        current_user.lobby_out_handle
      end
      current_user_set_id(nil)
      sign_out(:xuser)
    end

    def login_display?
      v = false
      v ||= params[:controller].start_with?("colosseum")
      v ||= params[:controller].start_with?("xy_records")
      v ||= params[:controller].start_with?("free_battles") && params[:edit_mode] != "adapter"
      v
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
      ua.bot? || request.user_agent.to_s.include?("Barkrowler")
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
