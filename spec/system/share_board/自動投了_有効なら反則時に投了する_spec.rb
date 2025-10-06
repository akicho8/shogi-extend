require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(auto_resign_key)
    visit_room({
        :room_key             => :test_room,
        :user_name            => "a",
        :fixed_member_names   => "a,b",
        :fixed_order_names    => "a,b",
        :handle_name_validate => "false",
        :fixed_order_state    => "to_o1_state",
        :autoexec             => "cc_auto_start",
        :auto_resign_key      => auto_resign_key,
        :RS_ENABLE            => "false",
      })
    piece_move("88", "55") # 55角を指した瞬間にモーダルが出ているため piece_move_o でのチェックはできない
    assert_selector(".IllegalModal")
    illegal_modal_close
  end

  it "無効だと順番設定は解除されていない" do
    case1("is_auto_resign_off")
    assert_order_on
  end

  it "有効だと順番設定は解除されている" do
    case1("is_auto_resign_on")
    assert_order_off
  end
end
