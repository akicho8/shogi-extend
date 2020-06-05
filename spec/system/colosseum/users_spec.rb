require "rails_helper"

# 意図的に実行する場合は rspec spec --tag slow_spec
RSpec.describe "対戦", type: :system, slow_spec: true do
  context "ログインしてない状態" do
    it "ログイン画面" do
      visit "/colosseum/battles"
      doc_image
    end

    it "アカウント登録" do
      visit "/xusers/sign_up"
      doc_image
    end

    it "パスワードを忘れた" do
      visit "/xusers/password/new"
      doc_image
    end
  end

  # できればクリックしたい
  it "プロフィール表示" do
    @alice = create(:colosseum_user)
    visit "/colosseum/users/#{@alice.id}"
    doc_image
  end

  it "プロフィール設定" do
    @alice = create(:colosseum_user)
    visit "/colosseum/users/#{@alice.id}/edit"
    doc_image
  end
end
