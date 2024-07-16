require "rails_helper"

RSpec.describe "基本", type: :system do
  it "/bin ならグループ一覧を出す" do
    visit2 "/bin"
    assert_title(/簡易ツール/)
  end

  it "グループ直下であればそのグループ内ページの一覧を出す" do
    visit2 "/bin/swars"
    assert_title(/将棋ウォーズ/)
  end

  it "Swars::UserScript" do
    visit2 "/bin/swars/user"
    assert_title(/将棋ウォーズ棋力一覧/)
  end

  describe "非表示スクリプト" do
    it "見えない" do
      visit2 "/bin/chore/index"
      assert_no_text("見えてはいけないスクリプト")
    end

    it "見える" do
      visit2 "/bin/chore/index", query: "*"
      assert_text("見えてはいけないスクリプト")
    end
  end
end
