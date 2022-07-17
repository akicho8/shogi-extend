require "#{__dir__}/shared_methods"

# このテストは ordered_members が nil のまま共有されるのをスキップするのを保証するので消してはいけない
RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    a_block do
      room_setup("my_room", "alice")
      begin
        visit "/share-board"                         # 再来
        hamburger_click
        room_setup_modal_handle                      # 「部屋に入る」を自分でクリックする
        find(".new_room_code input").set("my_room")  # 合言葉を入力する
        value = find(".new_user_name input").value
        assert { value == "alice" }                  # 以前入力したニックネームが復元されている
        find(".entry_button").click                  # 共有ボタンをクリックする
        find(".close_handle").click                  # 共有ボタンをクリックする
      end
      piece_move_o("17", "16", "☗1六歩")              # aliceは一人で初手を指した
    end
    b_block do
      room_setup("my_room", "bob")                   # bob が別の画面でログインし、alice と同じ部屋の合言葉を設定する
      assert_text("alice")                           # すでにaliceがいるのがわかる
    end
    a_block do
      assert_text("bob")                             # alice側の画面にはbobが表示されている
    end
    b_block do
      piece_move_o("33", "34", "☖3四歩")              # bobは2手目の後手を指せる
    end
    a_block do
      assert_text("☖3四歩")                          # aliceの画面にもbobの指し手の符号が表示されている
    end
  end
end
