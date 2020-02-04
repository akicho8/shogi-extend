#
# 注意点
#
# 1. iPhone でダウンロードとしたときだけ文字化けする対策をしてはいけない
#
#   if mobile_agent?
#     text_body = text_body.tosjis
#   end
#   とすれば文字化けしなくなるが、ぴよ将棋で読めなくなる
#
# 2. 激指ではクリップボードは UTF8 でないと読めないのでこれを入れてはいけない
#
#   if sjis_p?
#     text_body = text_body.tosjis
#   end
#
require "kconv"

module KifShowMod
  extend ActiveSupport::Concern

  private

  # curl -I http://localhost:3000/x/1.kif?inline=1
  # curl -I http://localhost:3000/x/1.kif?plain=1
  def kif_data_send
    text_body = current_record.to_cached_kifu(params[:format])

    if params[:copy_trigger]
      slack_message(key: "#{params[:format]}コピー", body: current_record.title)
    end

    if params[:plain].present?
      render plain: text_body
      return
    end

    send_data(text_body, type: Mime[params[:format]], filename: current_filename.public_send("to#{current_encode}"), disposition: current_disposition)
  end

  def current_disposition
    value = params[:disposition]

    unless value
      if key = [:inline, :attachment].find { |e| as_true_or_false(params[key]) }
        value ||= key
      end
    end

    value || :attachment
  end

  def current_filename
    "#{current_record.to_param}.#{params[:format]}"
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
