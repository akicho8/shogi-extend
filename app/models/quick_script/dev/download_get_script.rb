module QuickScript
  module Dev
    class DownloadGetScript < Base
      self.title = "CSVダウンロード(GET)"
      self.description = "CSVダウンロードを行う"
      self.form_method = :get
      self.params_add_submit_key = :exec

      # http://localhost:4000/bin/dev/download_get
      # http://localhost:3000/api/bin/dev/download_get
      # http://localhost:3000/api/bin/dev/download_get.csv
      def call
        if !submitted?
          self.button_label = "ダウンロード"
          "(ダウンロード開始前の文言)"
        else
          self.form_method = nil # ボタンを非表示にする
          flash[:notice] = "ダウンロードしました"
          redirect_to csv_url, hard_jump: true
          "(ダウンロード中または完了時の文言)"
        end
      end

      def render_format(format)
        super
        format.csv do
          controller.send_data(csv_content, filename: csv_filename)
        end
      end

      def csv_content
        "a,b,c"
      end

      def csv_filename
        "foo.csv"
      end

      def csv_url
        Rails.application.routes.url_helpers.url_for(:root) + "api/bin/#{params[:qs_group_key]}/#{params[:qs_page_key]}.csv"
      end
    end
  end
end
