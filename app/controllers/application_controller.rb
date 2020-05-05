class ApplicationController < ActionController::Base
  include LightSessionMethods
  include CurrentUserMod

  before_action do
    ActiveStorage::Current.host = request.base_url
  end

  before_action do
    request.env["exception_notifier.exception_data"] = {
      current_user_id: current_user&.id,
    }
  end

  # http://localhost:3000/?force_error=1
  # https://www.shogi-extend.com/?force_error=1
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
      helper_method :iframe_p
      helper_method :slack_message
    end

    def submitted?(name)
      params.key?(name)
    end

    def slack_message(params = {})
      SlackAgent.message_send(params.merge(ua: ua))
    end

    def iframe_p
      !!params[:iframe]
    end

    private

    def boolean_for(v)
      v.to_s == "true" || v.to_s == "1"
    end

    def h
      @h ||= view_context
    end
    delegate :tag, :link_to, :icon_tag, :auto_link, to: :h
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
