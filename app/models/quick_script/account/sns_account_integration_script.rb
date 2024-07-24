module QuickScript
  module Account
    class SnsAccountIntegrationScript < Base
      self.title = "アカウント連携"
      self.description = "他のSNSのアカウントを使ってログインできるようにする (Googleアカウント一つで充分)"
      self.nuxt_login_required_timing = :immediately

      def call
        if current_user
          redirect_to url_helpers.edit_user_url(current_user, social_connect_only: true), type: :hard
        end
      end
    end
  end
end
