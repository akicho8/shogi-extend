require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_app(room_key: :test_room, user_name: "alice")
    global_menu_open
    os_modal_open_handle                                                 # 「順番設定」モーダルを開く
    os_switch_toggle                                                # 右上の有効スイッチをクリック
    find(:button, text: "全体ｼｬｯﾌﾙ", exact_text: true).click        # 全体シャッフルする
    os_modal_close                                              # 閉じる (ヘッダーに置いている) とするがダイアログが表示される
    find(:button, text: "確定せずに閉じる", exact_text: true).click # 無視して閉じる
  end
end
