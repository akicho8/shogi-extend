module QuickScript
  module Dev
    class HrefRedirectScript < Base
      self.title = "外部リダイレクトのテスト"

      def call
        { href_redirect_to: "https://example.com/" }
      end
    end
  end
end
