module QuickScript
  module Chore
    class RedirectScript < Base
      self.title = "リダイレクトのテスト"

      def call
        { redirect_to: "https://example.com/" }
      end
    end
  end
end
