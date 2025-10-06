require "rails_helper"

RSpec.describe "基本", type: :system do
  it "/lab ならグループ一覧を出す" do
    visit_to "/lab"
    assert_title(/実験室/)
  end

  it "グループ直下であればそのグループ内ページの一覧を出す" do
    visit_to "/lab/swars"
    assert_title(/将棋ウォーズ/)
  end

  it "Swars::UserGroupScript" do
    visit_to "/lab/swars/user-group"
    assert_title(/将棋ウォーズプレイヤー情報一覧/)
  end

  describe "非表示スクリプト" do
    it "見えない" do
      visit_to "/lab/chore/index"
      assert_no_text("見えてはいけないスクリプト")
    end

    it "見える" do
      visit_to "/lab/chore/index", query: "*"
      assert_text("見えてはいけないスクリプト")
    end
  end
end
