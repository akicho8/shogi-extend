require "rails_helper"

RSpec.describe "その他", type: :system do
  it "符号の鬼" do
    visit2 "/xy"
    assert_text "符号の鬼"
  end

  describe "nuxt_login_required" do
    before do
      login_by("sysop")
    end
    it "login" do
      visit2 "/video/new", __nuxt_login_required_force: "login"
      assert_text "Google"
    end
    it "email" do
      visit2 "/video/new", __nuxt_login_required_force: "email"
      assert_text "メールアドレス"
    end
    it "name" do
      visit2 "/video/new", __nuxt_login_required_force: "name"
      assert_text "自己紹介"
    end
    it "ban" do
      visit2 "/video/new", __nuxt_login_required_force: "ban"
      assert_text "shogi-mode.el"
    end
  end
end
