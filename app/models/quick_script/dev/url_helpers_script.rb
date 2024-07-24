module QuickScript
  module Dev
    class UrlHelpersScript < Base
      self.title = "URLの確認"
      self.description = "Application.routes.url_helpers を参照する"

      def call
        url_helpers.edit_user_url(1)
      end
    end
  end
end
