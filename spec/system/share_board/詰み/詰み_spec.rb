require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app(body: SfenInfo.fetch("頭金で一手詰確認用").sfen)
    stand_click(:black, :G)
    place_click("52")
    assert_action_text("詰み")
  end
end
