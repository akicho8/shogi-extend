module QuickScript
  module Dev
    class RouterRedirectScript < Base
      self.title = "内部リダイレクトのテスト"

      def call
        { router_redirect_to: "/adapter" }
      end
    end
  end
end
