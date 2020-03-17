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
module PngShowMod
  extend ActiveSupport::Concern

  private

  # http://localhost:3000/x?description=&modal_id=8452d6171728a6ca1a2fbfbbc3aea23d&title=&turn=1
  # http://localhost:3000/x/8452d6171728a6ca1a2fbfbbc3aea23d.png?turn=1
  def png_file_send
    turn = current_record.adjust_turn(params[:turn])
    png = current_record.to_dynamic_png(params)
    send_data png, type: Mime[:png], disposition: current_disposition, filename: "#{current_record.to_param}-#{turn}.png"
  end
end
