require "rails_helper"

RSpec.describe "対戦", type: :system do
  before do
    Actb.setup
  end

  context "ログインしてない状態" do
    it "アカウント登録" do
      visit "/xusers/sign_up"
      doc_image
    end

    it "パスワードを忘れた" do
      visit "/xusers/password/new"
      doc_image
    end
  end

  it "プロフィール表示" do
    @alice = create(:user)
    visit "/users/#{@alice.id}"
    doc_image
  end

  it "プロフィール設定" do
    @alice = create(:user)
    visit "/users/#{@alice.id}/edit"
    doc_image
  end
end
