require "rails_helper"

RSpec.describe "認証", type: :system, login_spec: true do
  before do
    target_user_destroy
  end

  before do
    target_user_destroy
  end

  describe "SNS経由で新規登録しながらログイン" do
    it "works" do
      twitter_login
      assert_login_ok
    end
  end

  describe "メールアドレス重複" do
    it "works" do
      eval_code(%(User.create!(name: :alice, email: "#{system_test_twitter_account[:email]}", confirmed_at: Time.current)))
      twitter_login
      assert_text("メールアドレスとパスワードでログインしてください")
    end
  end

  def system_test_twitter_account
    Rails.application.credentials[:system_test_twitter_account]
  end

  def twitter_login
    visit "/"

    find(".NavbarItemLogin").click  # 「ログイン」クリック
    find("button.is-twitter").click # SNS経由ログインのなかから Twitter を選択

    # Twitter側のログインフォーム
    find("#username_or_email").set(system_test_twitter_account[:email])
    find("#password").set(system_test_twitter_account[:password])
    find("#allow.submit").click

    # 別のログインフォームに飛ばされたとき
    # find('input[name="session[username_or_email]"]').set("xxx")
  end

  # ログイン中になっている
  def assert_login_ok
    assert_selector(".NavbarItemProfileLink")
  end

  def target_user_destroy
    eval_code(%(User.where(email: "#{system_test_twitter_account[:email]}").destroy_all))
  end
end
