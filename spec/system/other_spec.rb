require "rails_helper"

RSpec.describe "その他", type: :system do
  it "符号の鬼" do
    XyMaster.setup
    visit "/xy"
    assert_text "符号の鬼"
    doc_image
  end

  it "実戦詰将棋" do
    TsMaster.setup
    visit "/practical-checkmate"
    assert_text "実戦詰将棋"
    doc_image
  end

  it "目隠し詰将棋" do
    visit "/blindfold"
    assert_text "目隠し詰将棋"
    doc_image
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
  end

  # it "ストップウォッチ" do
  #   visit "/stopwatch"
  #   assert_text "Rails"
  #   doc_image
  # end

  # describe "戦法トリガー事典" do
  #   it "一覧" do
  #     visit "/tactics"
  #     assert_text "Rails"
  #     doc_image
  #   end
  #
  #   describe "詳細" do
  #     it "囲い" do
  #       visit "/tactics/ダイヤモンド美濃"
  #       assert_text "ダイヤモンド美濃"
  #       doc_image
  #     end
  #
  #     it "戦型" do
  #       visit "/tactics/富沢キック"
  #       assert_text "ポンポン桂"
  #       doc_image
  #     end
  #
  #     it "手筋" do
  #       visit "/tactics/パンツを脱ぐ"
  #       assert_text "パンツを脱ぐ"
  #       doc_image
  #     end
  #   end
  #
  #   it "戦法ツリー" do
  #     visit "/tactics-tree"
  #     assert_text "Rails"
  #     doc_image
  #   end
end
