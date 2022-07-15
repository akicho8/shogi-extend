require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    a_block do
      room_setup("my_room", "alice")                     # aliceが部屋を作る
    end
    b_block do
      room_setup("my_room", "bob")                       # bobも同じ部屋に入る
    end
    c_block do
      room_setup("my_room", "carol")                     # carolは観戦目的で同じ部屋に入る
    end
    a_block do
      hamburger_click
      os_modal_handle                        # 「順番設定」モーダルを開く
      main_switch_toggle                         # 有効スイッチをクリック (最初なので同時に適用を押したの同じで内容も送信)
      order_toggle(3)                                    # 3番目のcarolさんの「OK」をクリックして「観戦」に変更
      apply_button                       # 適用クリック
      modal_close_handle          # 閉じる (ヘッダーに置いている)
    end
    c_block do
      assert_member_list(1, "is_turn_active", "alice") # 1人目(alice)に丸がついている
      assert_member_list(2, "is_turn_standby", "bob")     # 2人目(bob)は待機中
      assert_member_list(3, "is_watching", "carol")       # 3人目(carol)は観戦中
      piece_move_x("77", "76", "☗7六歩")              #  なので3番目のcarolは指せない
    end
    a_block do
      piece_move_o("77", "76", "☗7六歩")                 # 1番目のaliceが指す
    end
    b_block do
      piece_move_o("33", "34", "☖3四歩")                 # 2番目のbobが指す
    end
    c_block do
      piece_move_x("27", "26", "☗2六歩")              # 3番目のcarolは観戦者なので指せない
    end
    a_block do
      piece_move_o("27", "26", "☗2六歩")                 # 1順してaliceが3手目を指す
    end
  end
end
