module QuickScript
  module Dev
    class UrlHelpersScript < Base
      self.title = "URLの確認"
      self.description = "Application.routes.url_helpers を参照する"

      def call
        url_helpers.root_url
      end
    end
  end
end
