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

    if current_body_encode == :sjis
      text_body = text_body.tosjis
    end

    # if boolean_cast(params[:plain])
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

  def current_filename
    "#{current_record.to_param}.#{params[:format]}"
  end
end
