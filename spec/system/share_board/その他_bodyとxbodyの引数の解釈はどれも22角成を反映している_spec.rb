require "#{__dir__}/sb_support_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  describe "body" do
    it "sfen" do
      visit_app(body: SfenGenerator.santeme_kakunari)
      assert_soldier_exist(:black, "B", true)
    end
    it "半角スペースをドットに置換したsfen" do
      visit_app(body: DotSfen.escape(SfenGenerator.santeme_kakunari))
      assert_soldier_exist(:black, "B", true)
    end
  end
  describe "xbody" do
    it "URL安全なbase64形式のSFENを与える" do
      visit_app(xbody: SafeSfen.encode(SfenGenerator.santeme_kakunari))
      assert_soldier_exist(:black, "B", true)
    end
    it "SFENでなくKI2でもかまわない(これで大きなテキストも安全に渡せる)" do
      visit_app(xbody: SafeSfen.encode("76歩 34歩 22角成"))
      assert_soldier_exist(:black, "B", true)
    end
  end
end
