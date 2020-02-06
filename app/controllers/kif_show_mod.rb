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
#   if filename_sjis?
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

    if as_b(params[:copy_trigger])
      slack_message(key: "#{params[:format]}コピー", body: current_record.title)
    end

    if current_body_encode == :sjis
      text_body = text_body.tosjis
    end

    # if as_b(params[:plain])
    #   render plain: text_body
    #   return
    # end

    if current_disposition == :inline
      headers["Content-Type"] = current_type
      render plain: text_body
      return
    end

    # inline でこれを表示すると headers["Content-Transfer-Encoding"] = "binary" になっているため Capybara でテキストが文字化けする
    # send_data(text_body, type: Mime[params[:format]], filename: current_filename.public_send("to#{filename_encode}"), disposition: current_disposition)
    send_data(text_body, type: current_type, filename: current_filename.public_send("to#{filename_encode}"), disposition: current_disposition)
  end

  def current_type
    if current_body_encode == :sjis
      "text/plain; charset=Shift_JIS"
    else
      "text/plain; charset=UTF-8"
    end
  end

  def current_disposition
    value = params[:disposition]

    unless value
      if key = [:inline, :attachment].find { |e| as_b(params[e]) }
        value ||= key
      end
    end

    (value || :inline).to_sym
  end

  def current_filename
    "#{current_record.to_param}.#{params[:format]}"
  end

  def filename_encode
    (params[:filename_encode].presence || filename_encode_default).to_sym
  end

  def filename_encode_default
    if filename_sjis?
      :sjis
    else
      :utf8
    end
  end

  def filename_sjis?
    request.user_agent.to_s.match?(/Windows/i) || as_b(params[:shift_jis]) || as_b(params[:sjis])
  end

  def current_body_encode
    (params[:body_encode].presence || :utf8).to_sym
  end
end
