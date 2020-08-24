module FrontendScript
  class XclockAppScript
    concern :ZipDlMod do
      # http://localhost:3000/script/xclock-app.zip?remote_action=question_download
      def question_download
        if request.format.zip?
          unless current_user
            c.head :no_content
            return
          end

          t = Time.current

          zip_buffer = Zip::OutputStream.write_buffer do |zos|
            zip_scope.each do |record|
              zos.put_next_entry("#{record.lineage_key}/#{record.id}_#{record.title}.kif")

              str = record.to_kif
              if c.current_body_encode == :sjis
                str = str.tosjis
              end

              zos.write(str)
            end
          end

          sec = "%.2f s" % (Time.current - t)
          c.slack_message(key: "ZIP #{sec}", body: zip_filename)
          c.send_data(zip_buffer.string, type: Mime[params[:format]], filename: zip_filename, disposition: "attachment")
        end
      end

      def zip_filename
        parts = []
        parts << current_user.name
        parts << "将棋問題集"
        parts << Time.current.strftime("%Y%m%d%H%M%S")
        parts << c.current_body_encode
        parts << zip_scope.count
        str = parts.compact.join("_") + ".zip"
        str.public_send("to#{c.current_body_encode}")
      end

      def zip_scope
        # Xclock::Question.all
        s = current_user.xclock_questions
        # s = s.active_only
        s = s.includes(:ox_record)
        s = s.includes(:folder)
      end
    end
  end
end
