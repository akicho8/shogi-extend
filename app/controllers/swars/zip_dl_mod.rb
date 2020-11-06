require "kconv"

module Swars
  concern :ZipDlMod do
    private

    def zip_dl_perform
      if request.format.zip?
        t = Time.current

        zip_buffer = Zip::OutputStream.write_buffer do |zos|
          zip_scope.each do |battle|
            if str = battle.to_xxx(kifu_format_info.key)
              zos.put_next_entry("#{battle.key}.#{kifu_format_info.key}")
              if current_body_encode == :sjis
                str = str.tosjis
              end
              zos.write(str)
            end
          end
        end

        sec = "%.2f s" % (Time.current - t)
        slack_message(key: "ZIP #{sec}", body: zip_filename)
        send_data(zip_buffer.string, type: Mime[params[:format]], filename: zip_filename, disposition: "attachment")
      end
    end

    def zip_scope
      current_index_scope.order(battled_at: "desc").limit(zip_dl_max)
    end

    def zip_filename
      parts = []
      parts << "shogiwars"
      if current_swars_user
        parts << current_swars_user.key
      end
      parts << Time.current.strftime("%Y%m%d%H%M%S")
      parts << kifu_format_info.key
      parts << current_body_encode
      parts << zip_scope.count
      str = parts.compact.join("-") + ".zip"
      str.public_send("to#{current_body_encode}")
    end

    def zip_dl_max
      (params[:zip_dl_max].presence || AppConfig[:zip_dl_max_default]).to_i.clamp(0, AppConfig[:zip_dl_max_of_max])
    end

    def kifu_format_info
      @kifu_format_info ||= Bioshogi::KifuFormatInfo.fetch(zip_format_info.key)
    end

    def zip_format_info
      ZipFormatInfo.fetch(zip_format_key)
    end

    def zip_format_key
      params[:zip_format_key].presence || "kif"
    end
  end
end
