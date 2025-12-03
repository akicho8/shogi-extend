require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(auto_resign_key)
    visit_room({
        :user_name         => "a",
        :FIXED_MEMBER      => "a,b",
        :FIXED_ORDER       => "a,b",
        :room_after_create => :cc_auto_start_10m,
        :auto_resign_key   => auto_resign_key,
        :RS_FEATURE         => false,
      })
    piece_move("88", "55") # 55角を指した瞬間にモーダルが出ているため piece_move_o でのチェックはできない
    assert_selector(".IllegalModal")
    illegal_modal_close
  end

  it "無効だと順番設定は解除されていない" do
    case1 :is_auto_resign_off
    assert_order_on
  end

  it "有効だと順番設定は解除されている" do
    case1 :is_auto_resign_on
    assert_order_off
  end
end
