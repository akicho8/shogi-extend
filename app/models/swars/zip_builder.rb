# class ZipBuilder
#   attr_accessor :params
#
#   def initialize(params)
#     @params = {
#       zip_kifu_key: "kif",
#     }.merge(params)
#   end
#
#   def zip_file_save
#     t = Time.current
#
#     zip_buffer = Zip::OutputStream.write_buffer do |zos|
#       zip_scope.each do |battle|
#         if str = battle.to_cached_kifu(kifu_format_info.key)
#           zos.put_next_entry("#{battle.key}.#{kifu_format_info.key}")
#           if body_encode == :sjis
#             str = str.tosjis
#           end
#           zos.write(str)
#         end
#       end
#     end
#
#     sec = "%.2f s" % (Time.current - t)
#     slack_message(key: "ZIP #{sec}", body: zip_filename)
#     send_data(zip_buffer.string, type: Mime[params[:format]], filename: zip_filename, disposition: "attachment")
#   end
#
#   def zip_scope
#     params[:scope].order(battled_at: "desc").limit(zip_dl_max)
#   end
#
#   def zip_filename
#     parts = []
#     parts << "shogiwars"
#     if current_swars_user
#       parts << current_swars_user.key
#     end
#     parts << Time.current.strftime("%Y%m%d%H%M%S")
#     parts << kifu_format_info.key
#     parts << body_encode
#     parts << zip_scope.count
#     str = parts.compact.join("_") + ".zip"
#     str.public_send("to#{body_encode}")
#   end
#
#   def zip_dl_max
#     (params[:zip_dl_max].presence || AppConfig[:zip_dl_size]).to_i.clamp(0, AppConfig[:zip_dl_max])
#   end
#
#   def kifu_format_info
#     @kifu_format_info ||= Bioshogi::KifuFormatInfo.fetch(zip_kifu_info.key)
#   end
#
#   def zip_kifu_info
#     ZipKifuInfo.fetch(zip_kifu_key)
#   end
#
#   def zip_kifu_key
#     params[:zip_kifu_key].presence || "kif"
#   end
#
#   def body_encode
#     params[:body_encode].presence || "utf8"
#   end
# end
