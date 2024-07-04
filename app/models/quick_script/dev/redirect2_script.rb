module QuickScript
  module Dev
    class Redirect2Script < Base
      self.title = "リダイレクト2"
      self.description = "外部サイトにリダイレクトする"

      def call
        redirect_to "https://example.com/", allow_other_host: true
      end
    end
  end
end
