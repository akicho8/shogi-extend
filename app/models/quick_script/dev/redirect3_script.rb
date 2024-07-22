module QuickScript
  module Dev
    class Redirect3Script < Base
      self.title = "リダイレクト3 (Rails)"
      self.description = "controller.redirect_to で直接返す (これはうまくいかない)"

      def call
        if controller
          controller.response.headers["Content-Type"] = "application/html"
          controller.redirect_to "https://example.com/", status: 302, allow_other_host: true
        end
        nil
      end
    end
  end
end
