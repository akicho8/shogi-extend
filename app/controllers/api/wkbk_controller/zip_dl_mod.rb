module Api
  class WkbkController
    include EncodeMod

    concern :ZipDlMod do
      # http://localhost:3000/api/wkbk.zip?remote_action=question_download
      def question_download
        if request.format.zip?

          unless current_user
            head :no_content
            return
          end

          t = Time.current

          zip_buffer = Zip::OutputStream.write_buffer do |zos|
            zip_dl_scope.each do |record|
              entry = Zip::Entry.new(zos, "#{record.lineage_key}/#{record.id}_#{record.title}.kif")
              entry.time = Zip::DOSTime.from_time(record.created_at)
              zos.put_next_entry(entry)

              str = record.to_kif
              if current_body_encode == "Shift_JIS"
                str = str.encode(current_body_encode)
              end

              zos.write(str)
            end
          end

          sec = "%.2f s" % (Time.current - t)
          slack_message(key: "ZIP #{sec}", body: zip_filename)
          send_data(zip_buffer.string, type: Mime[params[:format]], filename: zip_filename, disposition: "attachment")
        end
      end

      def zip_filename
        parts = []
        parts << current_user.name
        parts << "将棋問題集"
        parts << zip_dl_scope.count
        parts << Time.current.strftime("%Y%m%d%H%M%S")
        parts << current_body_encode
        str = parts.compact.join("_") + ".zip"
        # str = str.public_send("to#{current_body_encode}")
        str
      end

      def zip_dl_scope
        # Wkbk::Question.all
        s = current_user.wkbk_questions
        # s = s.active_only
        s = s.includes(:ox_record)
        s = s.includes(:folder)
      end
    end
  end
end
