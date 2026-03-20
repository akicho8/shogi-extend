require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room(user_name: :a)
    sidebar_open
    order_modal_open_handle                                               # 「対局設定」モーダルを開く
    order_switch_on                                            # 右上の有効スイッチをクリック
    find(".swap_handle").click                                  # a が先後反転した
    order_modal_close_handle                                              # 閉じる (ヘッダーに置いている) とするがダイアログが表示される
    find(:button, text: "確定せずに閉じる", exact_text: true).click # 無視して閉じる
  end
end
