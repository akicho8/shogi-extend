module QuickScript
  module Dev
    class LoginRequired1Script < Base
      self.title = "ログインモーダル発動1"
      self.description = "ボタンを押したタイミングでログインモーダルを発動してログインしていないと先に進ませない"
      self.button_with_nuxt_login_required = true
      self.form_method = :get
    end
  end
end
