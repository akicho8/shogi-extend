require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(selector)
    visit_app(room_code: :test_room, fixed_user_name: "alice")

    hamburger_click
    menu_item_click("設定")               # モーダルを開く
    find(selector).click
    find(".close_handle").click           # 閉じる

    place_click("77")                     # 77を持って
    place_click("87")                     # 87をクリック
  end

  it "移動元をクリック" do
    case1(".is_move_cancel_reality")
    piece_move_x("27", "26", "☗2六歩")  # キャンセルされていないので別の手が指せない
  end

  it "他のセルをクリック" do
    case1(".is_move_cancel_standard")         # 「他のセルをクリック」選択
    piece_move_o("27", "26", "☗2六歩")    # キャンセルされたので別の手が指せる
  end
end
