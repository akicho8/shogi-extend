require "#{__dir__}/shared_methods"

RSpec.xdescribe "対局時計で初期配置に戻さずに対局開始しようとしている場合の確認モーダル", type: :system, share_board_spec: true do
  def case1
    visit_app({
        :user_name         => "a",
        :fixed_member      => "a,b",
        :fixed_order       => "a,b",
        :body              => "68S",
        :autoexec          => "cc_create,cc_modal_open_handle",
      })
    clock_play_button_click
    assert_selector(".dialog .modal-card-title", text: "ちょっと待って")
  end

  it "はい" do
    case1
    find(:button, exact_text: "はい").click
    assert_turn(0)
    assert_selector(".clock_box_human_status", text: "動作中", exact_text: true)
  end

  it "いいえ" do
    case1
    find(:button, exact_text: "いいえ").click
    assert_turn(1)
    assert_selector(".clock_box_human_status", text: "動作中", exact_text: true)
  end
end
