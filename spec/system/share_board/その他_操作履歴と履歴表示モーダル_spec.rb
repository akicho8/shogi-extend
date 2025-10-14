require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "操作履歴から過去の局面に戻る" do
    def case1(user_name)
      visit_room({
          :user_name    => user_name,
          :fixed_member => "alice,bob",
          :fixed_order  => "alice,bob",
          :quick_sync_key     => "is_quick_sync_off", # 手動同期にしておく
        })
    end
    window_a do
      case1(:alice)
    end
    window_b do
      case1(:bob)
    end
    window_a do
      piece_move_o("77", "76", "☗7六歩")
      assert_turn(1)
    end
    window_b do
      piece_move_o("33", "34", "☖3四歩")
      assert_turn(2)
    end
    window_a do
      action_log_row_of(1).click # 初手(76歩)の行をクリックしてモーダル起動
      apply_button               # N手目まで戻る実行
      assert_turn(1)             # 1手目に戻った
    end
    window_b do
      assert_turn(2)        # 戻るのはalice側だけなのでbob側は2手目のまま
    end
  end

  it "操作履歴モーダル内の補助機能" do
    window_a do
      visit_room({
          :user_name => :alice,
          :fixed_order => :alice,
          :fixed_order_state => "to_o1_state",
        })

      piece_move_o("77", "76", "☗7六歩")              # 初手を指す
      assert_turn(1)
      action_log_row_of(0).click                      # 初手(76歩)の行をクリックしてモーダル起動

      # ウィンドウが開きまくるけど page はそのままなので
      #  window = current_window
      #  find(...).click
      #  switch_to_window(window)
      # とする必要はない

      find(".KifCopyButton").click           # 「コピー」
      assert_action_text("棋譜コピー")

      return_to_current_window do
        find(".KentoButton").click             # 「KENTO」
      end
      assert_action_text("KENTO起動")

      return_to_current_window do
        find(".PiyoShogiButton").click         # 「ぴよ将棋」
      end
      assert_action_text("ぴよ将棋起動")

      find(".current_url_copy_handle").click # 「リンク」
      assert_action_text("棋譜URLコピー")

      find(".kifu_download_handle").click    # 「ダウンロード」
      assert_action_text("棋譜ダウンロード")

      find(".kifu_show_handle").click        # 「棋譜表示」
      assert_action_text("棋譜表示")
    end
  end

  it "操作履歴モーダル内で局面を調整する" do
    window_a do
      visit_app
      piece_move_o("77", "76", "☗7六歩")
      piece_move_o("33", "34", "☖3四歩")
      assert_turn(2)                                    # 現在2手目
      action_log_row_of(0).click                        # 一番上の2手目を記憶した行をクリックしてモーダル起動
      Capybara.within(".ActionLogModal") do
        assert_text("局面 #2")                          # 当然2手目になっている
        find(".button.previous").click                  # 「<」で1手目に進めると
        assert_text("局面 #1")                          # 1手目になっている
      end
      find(".apply_button").click                       # 「N手目まで戻る」
      assert_turn(1)                                    # 1手目に変更されている
    end
  end
end
