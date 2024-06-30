module QuickScript
  module Admin
    class LoginScript < Base
      self.title = "ログイン状態の確認"

      def call
        {
          :admin_user   => admin_user,
          :current_user => current_user,
        }
      end
    end
  end
end
