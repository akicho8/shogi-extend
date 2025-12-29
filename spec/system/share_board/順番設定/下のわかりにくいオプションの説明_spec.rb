require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(label, message)
    find(".OrderModal span", text: label, exact_text: false).find(:xpath, "..").find(".hint_icon").click
    assert_text(message)
  end

  it "works" do
    visit_room(user_name: :a)
    assert_room_created
    order_modal_open      # 「順番設定」モーダルを開く
    os_switch_toggle   # 右上の有効スイッチをクリック
    find(".tabs .order_tab_rule").click
    case1("X回指したら交代する", "1回にしておくのが無難")
  end
end
