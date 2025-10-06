require "rails_helper"

RSpec.describe "ユーザー", type: :system do
  describe "ログインしてない状態" do
    it "面倒なアカウント登録" do
      visit_to "http://localhost:3000/xusers/sign_up"
    end

    it "パスワードを忘れた" do
      visit_to "http://localhost:3000/xusers/password/new"
    end
  end

  it "プロフィール表示" do
    visit_to "http://localhost:3000/accounts/1"
  end

  it "プロフィール設定" do
    visit_to "http://localhost:3000/accounts/1/edit"
  end
end
