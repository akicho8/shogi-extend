require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    a_block do
      room_setup("my_room", "alice")
      hamburger_click
      os_modal_handle # 「順番設定」モーダルを開く
      main_switch_toggle  # 有効スイッチをクリック (最初なので同時に適用を押したの同じで内容も送信)
      apply_button                # 適用クリック
      assert_text "次は時計を設置してください"
    end
  end
end
