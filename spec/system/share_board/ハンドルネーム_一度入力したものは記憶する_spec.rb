require "#{__dir__}/sb_support_methods"

# このテストは ordered_members が nil のまま共有されるのをスキップするのを保証するので消してはいけない
RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a do
      room_setup_by_user(:a)

      # 再来
      begin
        visit_app
        sidebar_open
        gate_modal_open_handle                               # 「入退室」を自分でクリックする
        find(".new_room_key input").set(:test_room)  # 合言葉を入力する
        find(".new_user_name").find(:fillable_field, with: :a) # 以前入力したニックネームが復元されている
        find(".gate_enter_handle").click                   # 入室
        # find(".close_handle").click                   # 閉じる
        assert_room_created
      end

      piece_move_o("17", "16", "☗1六歩")              # aは一人で初手を指した
    end
    window_b do
      room_setup_by_user(:b)  # b が別の画面でログインし、a と同じ部屋の合言葉を設定する
      assert_text(:a)                           # すでにaがいるのがわかる
    end
    window_a do
      assert_text(:b)                             # a側の画面にはbが表示されている
    end
    window_b do
      piece_move_o("33", "34", "☖3四歩")              # bは2手目の後手を指せる
    end
    window_a do
      assert_text("☖3四歩")                          # aの画面にもbの指し手の符号が表示されている
    end
  end
end
