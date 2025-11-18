require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  # |----+----|
  # | 先 | 後 |
  # |----+----|
  # | a  | b  |
  # | c  |    |
  # |----+----|
  # の状態で2手毎なので a b a b c の順となる
  it "works" do
    visit_room({
        :user_name => "c",
        :FIXED_MEMBER => "a,b,c",
        :FIXED_ORDER => "a,b,c",
        :change_per => 2,
        :room_after_create => :cc_auto_start_10m,
      })
    place_click("11")
    assert_text "今はaさんの手番です"
    assert_text "cさんの手番は4手後です"
  end
end
