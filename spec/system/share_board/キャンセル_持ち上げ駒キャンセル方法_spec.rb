require "#{__dir__}/sb_support_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(selector)
    visit_app

    sidebar_open
    menu_item_click("設定")               # モーダルを開く
    find(".setting_tab_ui").click         # 「その他」タブ
    find(:label, text: selector, exact_text: true).click
    find(".close_handle").click           # 閉じる

    place_click("77")                     # 77を持って
    place_click("87")                     # 87をクリック
  end

  it "移動元をクリック" do
    case1("元の位置")
    piece_move_x("27", "26", "☗2六歩")  # キャンセルされていないので別の手が指せない
  end

  it "他のセルをクリック" do
    case1("移動先以外")                    # 「他のセルをクリック」選択
    piece_move_o("27", "26", "☗2六歩")    # キャンセルされたので別の手が指せる
  end
end
