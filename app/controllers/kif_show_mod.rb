module KifShowMod
  extend ActiveSupport::Concern

  private

  # curl -I http://localhost:3000/x/1.kif?inline=1
  # curl -I http://localhost:3000/x/1.kif?plain=1
  def kif_data_send
    require "kconv"

    text_body = current_record.to_cached_kifu(params[:format])

    if params[:copy_trigger]
      slack_message(key: "#{params[:format]}コピー", body: current_record.title)
    end

    # 激指ではクリップボードは UTF8 でないと読めない
    # if sjis_p?
    #   text_body = text_body.tosjis
    # end

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
      # if mobile_agent?
      #   text_body = text_body.tosjis
      # end
    end

    send_data(text_body, type: Mime[params[:format]], filename: current_filename.public_send("to#{current_encode}"), disposition: disposition)
  end

  def current_filename
    "#{current_record.key}.#{params[:format]}"
  end

  def current_encode
    params[:encode].presence || current_encode_default
  end

  def current_encode_default
    if sjis_p?
      "sjis"
    else
      "utf8"
    end
  end

  def sjis_p?
    request.user_agent.to_s.match(/Windows/i) || params[:shift_jis].present? || params[:sjis].present?
  end
end
