class ApplicationController < ActionController::Base
  include CurrentUserMod

  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  attr_accessor :layout_type

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

  # for devise
  # ログインしたあとに移動するパス
  # https://notsleeeping.com/archives/2487
  def after_sign_in_path_for(resource_or_scope)
    return_to = session[:return_to]
    session[:return_to] = nil

    # devise経由でログインしたときでも session と cookie に設定する
    # これを入れないと管理者でログインしたときに devise ではログインしているが
    # アプリではログインしたときは current_user が nil になってしまう
    current_user_set(resource_or_scope)

    return_to || :root
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
