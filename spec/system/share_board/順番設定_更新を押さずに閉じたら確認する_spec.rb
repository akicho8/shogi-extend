require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_app(room_code: :my_room, fixed_user_name: "alice")
    hamburger_click
    os_modal_handle                      # 「順番設定」モーダルを開く
    os_switch_toggle                   # 右上の有効スイッチをクリック
    find(".shuffle_handle").click        # シャッフルする
    modal_close_handle                   # 閉じる (ヘッダーに置いている) とするがダイアログが表示される
    find(:button, text: "更新せずに閉じる", exact_text: true).click # 無視して閉じる
  end
end
