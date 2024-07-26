module QuickScript
  module Dev
    class InvalidateBasicAuthScript < Base
      self.title = "BASIC認証のリセット"
      self.description = "BASIC認証をリセットする"

      def call
        redirect_to url_helpers.admin_root_url(invalidate_basic_auth: true), type: :hard
      end
    end
  end
end
