require "rails_helper"

RSpec.describe "認証", type: :system do
  before do
    eval_code(%(User.destroy_all))
  end

  # cd ~/src/shogi-extend/ && BROWSER_DEBUG=1 rspec ~/src/shogi-extend/spec/system/login_spec.rb -e 'SNS経由で新規登録しながらログイン'
  describe "SNS経由で新規登録しながらログイン" do
    it "works" do
      twitter_login
      assert_login_ok
    end
  end

  # cd ~/src/shogi-extend/ && BROWSER_DEBUG=1 rspec ~/src/shogi-extend/spec/system/login_spec.rb -e 'メールアドレス重複'
  describe "メールアドレス重複" do
    it "works" do
      eval_code(%(User.create!(name: "alice", email: "#{system_test_twitter_account[:email]}", confirmed_at: Time.current)))
      twitter_login
      assert_text("メールアドレスとパスワードでログインしてください")
    end
  end

  def system_test_twitter_account
    Rails.application.credentials[:system_test_twitter_account]
  end

  def eval_code(code)
    visit "http://localhost:3000/eval?#{code.to_query(:code)}"
  end

  def twitter_login
    visit "/"

    find(".NavbarItemLogin").click  # 「ログイン」クリック
    find("button.is-twitter").click # SNS経由ログインのなかから Twitter を選択

    # Twitter側のログインフォーム
    find("#username_or_email").set(system_test_twitter_account[:email])
    find("#password").set(system_test_twitter_account[:password])
    find("#allow.submit").click
  end

  # ログイン中になっている
  def assert_login_ok
    assert_selector(".NavbarItemProfileLink")
  end
end
