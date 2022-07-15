require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(label, message)
    find(".OrderSettingModal span", text: label, exact_text: true).click
    assert_text(message)
  end

  it "works" do
    visit_app(room_code: :my_room, force_user_name: "alice")
    hamburger_click
    os_modal_handle    # 「順番設定」モーダルを開く
    main_switch_toggle # 右上の有効スイッチをクリック
    case1("反則制限", "二歩")
    case1("アバター", "玉として表示します")
    case1("シャウト", "駒が無駄に叫びます")
    case1("N手毎交代", "1人10手毎交代のようなルール")
    case1("手番制限", "手番の人だけが駒を動かせる")
  end
end
