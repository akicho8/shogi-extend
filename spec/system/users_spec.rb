require "rails_helper"

RSpec.describe "ユーザー", type: :system do
  before do
    Actb.setup
  end

  context "ログインしてない状態" do
    it "面倒なアカウント登録" do
      visit "/xusers/sign_up"
      doc_image
    end

    it "パスワードを忘れた" do
      visit "/xusers/password/new"
      doc_image
    end
  end

  it "プロフィール表示" do
    alice = create(:user)
    visit "/accounts/#{alice.id}"
    doc_image
  end

  it "プロフィール設定" do
    alice = create(:user)
    visit "/accounts/#{alice.id}/edit"
    doc_image
  end

  it "名前がないときプロフィール設定に飛ばされる" do
    alice = create(:user, name: "")
    visit "/?_user_id=#{alice.id}"
    assert { current_path == "/accounts/#{alice.id}/edit" }
  end
end
