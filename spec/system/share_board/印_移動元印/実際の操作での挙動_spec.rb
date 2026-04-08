require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(params = {})
    visit_app({
        :body                     => SfenInfo.fetch("盤上は玉のみで他持駒").sfen,
        :origin_mark_behavior_key => :omb_with_self,
        **params,
      })
  end

  describe "盤上" do
    it "戻す" do
      case1(origin_mark_behavior_key: :omb_with_self)
      board_place("59").click
      assert_selector(".place_5_9 .OriginMarkLayer")
      board_place("59").click
      assert_no_selector(".place_5_9 .OriginMarkLayer")
    end

    it "指す" do
      case1(origin_mark_behavior_key: :omb_with_self)
      board_place("59").click
      assert_selector(".place_5_9 .OriginMarkLayer")
      board_place("58").click
      assert_no_selector(".place_5_9 .OriginMarkLayer")
    end
  end

  describe "持駒" do
    it "戻す" do
      case1(origin_mark_behavior_key: :omb_with_self)
      stand_piece(:black, :P).click
      assert_selector(".Membership.is_black .OriginMarkLayer")
      stand_of(:black).click
      assert_no_selector(".Membership.is_black .OriginMarkLayer")
    end

    it "指す" do
      case1(origin_mark_behavior_key: :omb_with_self)
      stand_piece(:black, :P).click
      assert_selector(".Membership.is_black .OriginMarkLayer")
      board_place("55").click
      assert_no_selector(".Membership.is_black .OriginMarkLayer")
    end
  end
end
