module QuickScript
  module Dev
    class LoginRequired2Script < Base
      self.title = "ログインモーダル発動2"
      self.description = "読み込みが終わったタイミングで nuxt_login_required を実行する"
      self.auto_exec_action = "nuxt_login_required"
    end
  end
end
