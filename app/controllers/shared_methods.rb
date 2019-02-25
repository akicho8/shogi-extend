module SharedMethods
  extend ActiveSupport::Concern

  included do
    before_action only: [:edit, :update, :destroy] do
      unless sysop?
        redirect_to :root, alert: "アクセス権限がありません"
      end
    end

    rescue_from "Warabi::WarabiError" do |exception|
      if request.format.json?
        render json: {error_message: exception.message.lines.first.strip}
      else
        h = ApplicationController.helpers
        lines = exception.message.lines
        message = lines.first.strip.html_safe
        if field = lines.drop(1).presence
          message += h.tag.div(field.join.html_safe, :class => "error_message_pre").html_safe
        end
        if v = exception.backtrace
          message += h.tag.div(v.first(8).join("\n").html_safe, :class => "error_message_pre").html_safe
        end
        behavior_after_rescue(message)
      end
    end
  end

  def show
    access_log_create

    respond_to do |format|
      format.html
      format.any { kifu_send_data }
    end
  end

  private

  def current_filename
    "#{current_record.key}.#{params[:format]}"
  end

  # curl -I http://localhost:3000/x/1.kif?inline=1
  # curl -I http://localhost:3000/x/1.kif?plain=1
  def kifu_send_data
    text_body = current_record.to_s_kifu(params[:format])

    if params[:shift_jis].present? || params[:sjis].present?
      text_body = text_body.tosjis
    end

    if params[:plain].present?
      render plain: text_body
      return
    end

    if params[:inline].present?
      disposition = "inline"
    else
      disposition = "attachment"

      # ↓これをやるとコピーのときに sjis 化されてぴよで読み込めなくなる
      #
      # iPhone で「ダウンロード」としたときだけ文字化けする対策(sjisなら文字化けない)
      # if access_from_mobile?
      #   text_body = text_body.tosjis
      # end
    end

    require "kconv"
    send_data(text_body, type: Mime[params[:format]], filename: current_filename.public_send("to#{current_encode}"), disposition: disposition)
  end

  def current_encode
    params[:encode].presence || current_encode_default
  end

  def current_encode_default
    if request.user_agent.to_s.match(/Windows/i)
      "sjis"
    else
      "utf8"
    end
  end

  def behavior_after_rescue(message)
    redirect_to :root, danger: message
  end

  def access_log_create
  end
end
