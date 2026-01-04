require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "対局中は出ない" do
    visit_room({
        :body              => SfenInfo.fetch("頭歩で王手確認用").sfen,
        :user_name         => "a",
        :FIXED_MEMBER      => "a,b",
        :FIXED_ORDER       => "a,b",
        :room_after_create => :cc_auto_start_10m,
        :RESEND_FEATURE    => false,
      })
    stand_piece(:black, :P).click
    board_place("52").click
    assert_no_action_text "王手"
  end

  it "感想戦中は出る" do
    visit_app(body: SfenInfo.fetch("頭歩で王手確認用").sfen)
    stand_piece(:black, :P).click
    board_place("52").click
    assert_action_text "王手"
  end
end
