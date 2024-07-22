module QuickScript
  module Dev
    class CsvDownloadPostScript < Base
      self.title = "CSVダウンロード(POST)"
      self.description = "CSVダウンロードを行う"
      self.form_method = :post

      # http://localhost:4000/lab/dev/download_post
      # http://localhost:3000/api/lab/dev/download_post
      # http://localhost:3000/api/lab/dev/download_post.csv
      def call
        if request_get?
          self.button_label = "ダウンロード"
          "(ダウンロード開始前の文言)"
        else
          self.form_method = nil # ボタンを非表示にする
          flash[:notice] = "ダウンロードしました"
          redirect_to download_url, type: :hard
          "(ダウンロード中または完了時の文言)"
        end
      end

      def render_format(format)
        super
        format.csv do
          controller.send_data(download_content, filename: download_filename)
        end
      end

      def download_content
        "a,b,c"
      end

      def download_filename
        "foo.csv"
      end

      def download_url
        self.class.qs_api_url(:csv)
      end
    end
  end
end
