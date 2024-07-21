module QuickScript
  module Dev
    class LoginRequired1Script < Base
      self.title = "ログインモーダル発動1"
      self.description = "ボタンを押したタイミングでログインモーダルを発動してログインしていないと先に進ませない"
      self.nuxt_login_required_timing = :later
      self.form_method = :get
    end
  end
end
