require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(label, message)
    find(".OrderSettingModal span", text: label, exact_text: true).click
    assert_text(message, wait: 10)
    assert_no_text(message, wait: 60)
  end

  it "works" do
    visit_app(room_code: :my_room, fixed_user_name: "alice")
    hamburger_click
    os_modal_handle    # 「順番設定」モーダルを開く
    os_switch_toggle   # 右上の有効スイッチをクリック
    case1("反則", "反則は「二歩」「王手放置」「駒ワープ」「死に駒」のみが対象です")
    case1("アバター", "自分のアバターを玉として表示します")
    case1("シャウト", "駒を動かされたり取られたりしたとき駒が無駄に叫びます")
    case1("N手毎交代", "1人10手毎交代のようなルールにできます")
    case1("手番制限", "制限すると手番の人だけが駒を動かせるようになります")
  end
end
