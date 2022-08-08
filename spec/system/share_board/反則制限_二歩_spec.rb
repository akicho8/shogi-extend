require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  describe "二歩" do
    it "できる" do
      visit_app(body: "position sfen 9/9/9/9/9/9/9/9/8P b P 1", foul_limit_key: "is_foul_limit_on") # 19に歩がある
      find(".Membership.is_black .piece_P").click # 持駒の歩を持つ
      find(".place_1_8").click                    # 18打
      assert_no_selector(".place_1_8.current")    # 反則できないモードなので打てない
    end
    it "できない" do
      visit_app(body: "position sfen 9/9/9/9/9/9/9/9/8P b P 1", foul_limit_key: "is_foul_limit_off") # 19に歩がある
      find(".Membership.is_black .piece_P").click # 持駒の歩を持つ
      find(".place_1_8").click                    # 18打
      assert_selector(".place_1_8.current")       # 反則できるモードなので打てる
    end
  end
end
