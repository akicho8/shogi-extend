require "rails_helper"

RSpec.describe "ユーザー", type: :system do
  describe "ログインしてない状態" do
    it "面倒なアカウント登録" do
      visit "http://localhost:3000/xusers/sign_up"
    end

    it "パスワードを忘れた" do
      visit "http://localhost:3000/xusers/password/new"
    end
  end

  it "プロフィール表示" do
    visit "http://localhost:3000/accounts/1"
  end

  it "プロフィール設定" do
    visit "http://localhost:3000/accounts/1/edit"
  end

  it "ぴよ将棋設定" do
    visit "/settings/piyo_shogi"
  end

  it "メールアドレス設定" do
    visit "/settings/email"
  end

  # it "名前がないときプロフィール設定に飛ばされる" do
  #   alice = create(:user, name: "")
  #   visit "http://localhost:3000/?_user_id=#{alice.id}"
  #   assert_current_path "/accounts/#{alice.id}/edit", ignore_query: true
  # end
end
