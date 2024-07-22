module QuickScript
  module Dev
    class ZipDownloadPostScript < Base
      self.title = "ZIPダウンロード(POST)"
      self.description = "ZIPダウンロードを行う"
      self.form_method = :post

      # http://localhost:4000/lab/dev/download_post
      # http://localhost:3000/api/lab/dev/download_post
      # http://localhost:3000/api/lab/dev/download_post.zip
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
        format.zip do
          controller.send_data(download_content, filename: download_filename)
        end
      end

      def download_content
        "a,b,c"
      end

      def download_filename
        "foo.zip"
      end

      def download_url
        self.class.qs_api_url(:zip)
      end
    end
  end
end
