require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room(user_name: :a)
    assert_room_created
    order_modal_open      # 「順番設定」モーダルを開く
    os_switch_toggle   # 右上の有効スイッチをクリック
    find(".tabs .order_tab_rule").click
    find(".OrderModal span", text: "対局中に思考印が見える人", exact_text: false).find(:xpath, "..").find(".hint_icon").click
    assert_text("副ボタンまたは右上の鉛筆マークをONにすると盤の升目に印をつけることができます")
  end
end
