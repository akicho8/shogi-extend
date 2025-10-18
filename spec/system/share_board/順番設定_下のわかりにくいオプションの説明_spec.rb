require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(label, message)
    find(".OrderSettingModal span", text: label, exact_text: false).find(:xpath, "..").find(".hint_icon").click
    assert_text(message, wait: 10)
    assert_no_text(message, wait: 30)
  end

  it "works" do
    visit_room(user_name: :a)
    assert_room_created
    os_modal_open      # 「順番設定」モーダルを開く
    os_switch_toggle   # 右上の有効スイッチをクリック
    case1("反則", "反則は「二歩」「王手放置」「駒ワープ」「死に駒」のみが対象です")
    case1("X回指したら交代する", "1回にしておくのが無難")
  end
end
