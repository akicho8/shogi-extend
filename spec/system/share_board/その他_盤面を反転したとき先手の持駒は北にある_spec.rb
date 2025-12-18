require "#{__dir__}/sb_support_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app(body: SfenGenerator.santeme_kakunari, viewpoint: "white") # 反転する
    Capybara.assert_selector(".is_position_north .piece_B")             # 北側の駒台に角がある
  end
end
