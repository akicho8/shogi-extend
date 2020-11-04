module Api
  class EmoxController
    include EncodeMod

    concern :ZipDlMod do
      # http://localhost:3000/api/emox.zip?remote_action=question_download
      def question_download
        if request.format.zip?

          unless current_user
            head :no_content
            return
          end

          t = Time.current

          zip_buffer = Zip::OutputStream.write_buffer do |zos|
            zip_scope.each do |record|
              zos.put_next_entry("#{record.lineage_key}/#{record.id}_#{record.title}.kif")

              str = record.to_kif
              if current_body_encode == :sjis
                str = str.tosjis
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
        parts << Time.current.strftime("%Y%m%d%H%M%S")
        parts << current_body_encode
        parts << zip_scope.count
        str = parts.compact.join("_") + ".zip"
        str.public_send("to#{current_body_encode}")
      end

      def zip_scope
        # Emox::Question.all
        s = current_user.emox_questions
        # s = s.active_only
        s = s.includes(:ox_record)
        s = s.includes(:folder)
      end
    end
  end
end
