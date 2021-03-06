#
# 注意点
#
# 1. iPhone でダウンロードとしたときだけ文字化けする対策をしてはいけない
#
#   if request.from_smartphone?
#     text_body = text_body.encode("Shift_JIS")
#   end
#   とすれば文字化けしなくなるが、ぴよ将棋で読めなくなる
#
# 2. 激指ではクリップボードは UTF8 でないと読めないのでこれを入れてはいけない
#
#   if filename_shift_jis?
#     text_body = text_body.encode("Shift_JIS")
#   end
#
require "kconv"

module KifShowMethods
  extend ActiveSupport::Concern

  private

  # curl -I http://localhost:3000/x/1.kif?inline=1
  # curl -I http://localhost:3000/x/1.kif?plain=1
  def kif_data_send
    if request.format.bod?
      text_body = KifuParser.new(source: current_record.kifu_body, to_format: "bod", turn: params[:turn]).to_xxx
    else
      text_body = current_record.to_xxx(params[:format])
    end

    if current_body_encode == "Shift_JIS"
      text_body = text_body.encode(current_body_encode)
    end

    # if boolean_for(params[:plain])
    #   render plain: text_body
    #   return
    # end

    if current_disposition == :inline
      headers["Content-Type"] = current_type
      render plain: text_body
      return
    end

    # inline でこれを表示すると headers["Content-Transfer-Encoding"] = "binary" になっているため Capybara でテキストが文字化けする
    # filename = current_filename.public_send("to#{current_filename_encode}")
    send_data(text_body, type: current_type, filename: current_filename, disposition: current_disposition)
  end

  def current_filename
    "#{current_record.to_param}.#{params[:format]}"
  end
end
