require "#{__dir__}/shared_methods"

RSpec.describe "対局時計で初期配置に戻さずに対局開始しようとしている場合の確認モーダル", type: :system, share_board_spec: true do
  def case1
    visit_app({
        :room_key            => :test_room,
        :user_name            => "a",
        :fixed_member_names   => "a,b",
        :fixed_order_names    => "a,b",
        :fixed_order_state    => "to_o1_state",
        :handle_name_validate => "false",
        :body                 => "68S",
        :autoexec             => "cc_create,cc_modal_open_handle",
      })
    clock_play_button_click
    assert_selector(".dialog .modal-card-title", text: "ちょっと待って")
  end

  it "はい" do
    case1
    find(:button, exact_text: "はい").click
    assert_selector(".ClockBoxModal .modal-card-title", exact_text: "対局時計動作中")
  end

  it "いいえ" do
    case1
    find(:button, exact_text: "いいえ").click
    assert_text("「初期配置に戻す」")
    assert_selector(".ClockBoxModal .modal-card-title", exact_text: "対局時計停止中")
  end
end
