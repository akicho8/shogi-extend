require "rails_helper"

RSpec.describe "共有将棋盤", type: :system do
  before do
    @alice_window = Capybara.open_new_window
    @bob_window = Capybara.open_new_window
    @carol_window = Capybara.open_new_window
  end

  after do
    [@alice_window, @bob_window, @carol_window].each(&:close)
  end

  def a_block(&block)
    if block
      Capybara.within_window(@alice_window, &block)
    else
      Capybara.switch_to_window(@alice_window)
    end
  end

  def b_block(&block)
    if block
      Capybara.within_window(@bob_window, &block)
    else
      Capybara.switch_to_window(@bob_window)
    end
  end

  def c_block(&block)
    if block
      Capybara.within_window(@carol_window, &block)
    else
      Capybara.switch_to_window(@carol_window)
    end
  end

  it "最初に来たときのタイトルが正しい" do
    a_block do
      visit "/share-board"
      assert_text("共有将棋盤")
      doc_image
    end
  end

  it "駒落ちで開始したとき△側が下に来ている" do
    a_block do
      visit "/share-board?body=position+sfen+4k4%2F9%2F9%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+w+-+1&turn=0&title=%E6%8C%87%E3%81%97%E7%B6%99%E3%81%8E%E3%83%AA%E3%83%AC%E3%83%BC%E5%B0%86%E6%A3%8B"
      assert_selector(".CustomShogiPlayer .is_viewpoint_white")
      doc_image
    end
  end

  it "合言葉を含むURLから来てハンドルネーム入力して接続して駒を動かす" do
    a_block do
      visit "/share-board?room_code=foo"                # 合言葉を含むURLから来る
      assert_selector(".RealtimeShareModal")            # 「合言葉の設定と共有」のモーダルが自動的に表示されている
      assert_text("合言葉の設定と共有")                 # 「合言葉の設定と共有」のモーダルのタイトルも正しい
      first(".new_user_name input").set("alice")        # ハンドルネームを入力する
      first(".share_button").click                      # 共有ボタンをクリックする
      assert_text("alice")                              # 入力したハンドルネームの人がメンバーリストに表示されている
      assert_move("77", "76", "☗7六歩")
      doc_image
    end
  end

  # BROWSER_DEBUG=1 rspec ~/src/shogi-extend/spec/system/share_board_spec.rb -e '一度入力したハンドルネームは記憶'
  # Capybara.default_max_wait_time = 1
  # このテストは ordered_members が nil のまま共有されるのをスキップできるのを保証するので消してはいけない
  it "一度入力したハンドルネームは記憶" do
    a_block do
      room_setup("my_room", "alice")

      begin
        visit "/share-board"                                      # 再来
        side_menu_open
        menu_item_click("合言葉の設定と共有")                    # 「合言葉の設定と共有」を自分でクリックする
        first(".new_room_code input").set("my_room")              # 合言葉を入力する
        value = first(".new_user_name input").value
        assert { value == "alice" }                               # 以前入力したニックネームが復元されている
        first(".share_button").click                              # 共有ボタンをクリックする
      end

      assert_move("59", "58", "☗5八玉")                        # aliceは一人で初手を指した
    end
    b_block do
      # bob が別の画面でログインする
      room_setup("my_room", "bob")                            # alice と同じ部屋の合言葉を設定する
      assert_text("alice")                                    # すでにaliceがいるのがわかる
      doc_image("bobはaliceの盤面を貰った")                   # この時点で▲58玉が共有されている
    end
    a_block do
      assert_text("bob")                                        # alice側の画面にはbobが表示されている
    end
    b_block do
      assert_move("33", "34", "☖3四歩")                      # bobは2手目の後手を指せる
    end
    a_block do
      assert_text("☖3四歩")                                    # aliceの画面にもbobの指し手の符号が表示されている
      doc_image("aliceとbobは画面を共有している")
    end
  end

  # cd ~/src/shogi-extend/ && BROWSER_DEBUG=1 rspec ~/src/shogi-extend/spec/system/share_board_spec.rb -e 'タイトル共有'
  describe "タイトル共有" do
    it "works" do
      a_block do
        room_setup("my_room", "alice")         # alceが部屋を作る
      end
      b_block do
        room_setup("my_room", "bob")           # bobもaliceと同じ合言葉で部屋を作る
        first(".title_edit_navbar_item").click # タイトル変更モーダルを開く
        within(".modal-card") do
          first("input").set("(new_title)")    # 別のタイトルを入力
          find(".button.is-primary").click     # 更新ボタンを押す
        end
      end
      a_block do
        assert_text("(new_title)")             # alice側のタイトルが変更されている
      end
    end
  end

  # cd ~/src/shogi-extend/ && BROWSER_DEBUG=1 rspec ~/src/shogi-extend/spec/system/share_board_spec.rb -e '対局時計'
  describe "対局時計" do
    INITIAL_MAIN_MIN = 5

    it "works" do
      a_block do
        room_setup("my_room", "alice")             # aliceが部屋を作る
      end
      b_block do
        room_setup("my_room", "bob")               # bobも同じ部屋に入る
      end
      a_block do
        side_menu_open
        menu_item_click("対局時計の設置")         # 「対局時計の設置」モーダルを開く
        assert_clock_off                           # 時計はまだ設置されていない
        find(".main_switch").click                 # 設置する
        assert_clock_on                            # 時計が設置された
      end
      b_block do
        assert_clock_on                            # 同期してbob側にも設置されている
      end
      a_block do
        chess_clock_set(0, INITIAL_MAIN_MIN, 0, 0) # aliceが時計を設定する
        find(".play_button").click                 # 開始
        first(".close_button_for_capybara").click  # 閉じる (ヘッダーに置いている)
      end
      b_block do
        assert_white_read_sec(INITIAL_MAIN_MIN)    # bob側は秒読みが満タン
      end
      a_block do
        assert_move("27", "26", "☗2六歩")         # 初手を指す
        assert_clock_active_white                  # 時計を同時に押したので後手がアクティブになる
      end
      b_block do
        assert_clock_active_white                  # bob側も後手がアクティブになっている
        sleep(INITIAL_MAIN_MIN)                    # ここでは3秒ぐらいになってるけどさらに秒読みぶん待つ
        assert_white_read_sec(0)                   # 秒読みが0になっている
        assert_text("時間切れで☗の勝ち！")         # 時間切れのダイアログの表示(1回目)
        find(".button.is-primary").click           # それを閉じる
      end
      a_block do
        assert_text("時間切れで☗の勝ち！")         # alice側でも時間切れのダイアログが表示されている
        find(".button.is-primary").click           # それを閉じる
      end
      b_block do
        assert_move("33", "34", "☖3四歩")          # bobは時間切れになったがそれを無視して指した
        assert_white_read_sec(INITIAL_MAIN_MIN)    # すると秒読みが復活した
        assert_clock_active_black                  # 時計も相手に切り替わった
      end
      a_block do
        assert_clock_active_black                  # alice側もaliceがアクティブになった
        assert_white_read_sec(INITIAL_MAIN_MIN)    # bobの秒読みが復活している
        assert_move("77", "76", "☗7六歩")          # aliceは3手目を指した
        assert_clock_active_white                  # bobに時計が切り替わった
      end
      b_block do
        assert_clock_active_white                  # bob側もbob側にの時計に切り替わった
        sleep(INITIAL_MAIN_MIN)                    # bobは再び時間切れになるまで待った
        assert_white_read_sec(0)                   # また0時間切れになった
        assert_text("時間切れで☗の勝ち！")         # 2度目のダイアログが出た
      end
      a_block do
        assert_text("時間切れで☗の勝ち！")         # alice側でもダイアログが出た
      end
    end
  end

  # cd ~/src/shogi-extend/ && BROWSER_DEBUG=1 rspec ~/src/shogi-extend/spec/system/share_board_spec.rb -e '手番が来たら知らせる設定'
  xit "手番が来たら知らせる設定" do
    room_setup("my_room", "alice")
    side_menu_open
    menu_item_click("手番が来たら知らせる設定")    # 「手番が来たら知らせる設定」を自分でクリックする
    find(".TurnNotifyModal select").select("alice") # 上家設定
    find(".TurnNotifyModal .apply_button").click    # 適用
    assert_move("77", "76", "☗7六歩")              # aliceが1手指す
    assert_text("(通知効果音)")                     # 通知があった
  end

  # cd ~/src/shogi-extend/ && BROWSER_DEBUG=1 rspec ~/src/shogi-extend/spec/system/share_board_spec.rb -e '順番設定で手番お知らせ'
  describe "順番設定で手番お知らせ" do
    it "works" do
      a_block do
        room_setup("my_room", "alice")                     # aliceが部屋を作る
      end
      b_block do
        room_setup("my_room", "bob")                       # bobも同じ部屋に入る
        side_menu_open
        menu_item_click("順番設定")                       # 「順番設定」モーダルを開く (まだ無効の状態)
      end
      a_block do
        side_menu_open
        menu_item_click("順番設定")                       # 「順番設定」モーダルを開く
        find(".main_switch").click                         # 有効スイッチをクリック (最初なので同時に適用を押したの同じで内容も送信)
        assert_text("aliceさんが順番設定を有効にしました") # aliceが有効にしたことが(ActionCable経由で)自分に伝わった
        first(".close_button_for_capybara").click          # 閉じる (ヘッダーに置いている)
      end
      b_block do
        assert_text("aliceさんが順番設定を有効にしました") # aliceが有効にしたことがbobに伝わった
        assert_selector(".OrderSettingModal .b-table")     # 同期しているのでbob側のモーダルも有効になっている
        first(".close_button_for_capybara").click          # 閉じる (ヘッダーに置いている)
        assert_member_list(1, "is_current_player", "alice")         # 1人目(alice)に丸がついている
        assert_member_list(2, "is_other_player", "bob")           # 2人目(bob)は待機中
        assert_no_move("77", "76", "☗7六歩")              # なので2番目のbobは指せない
      end
      a_block do
        assert_member_list(1, "is_current_player", "alice")         # 1人目(alice)に丸がついている
        assert_member_list(2, "is_other_player", "bob")    # 2人目(bob)は待機中
        assert_move("77", "76", "☗7六歩")                 # aliceが1番目なので指せる
      end
      b_block do
        assert_text("(通知効果音)")                    # bobさんだけに牛が知らせている
      end
      a_block do
        assert_text("次はbobさんの手番です")
        assert_no_move("33", "34", "☖3四歩")              # aliceもう指したので指せない
        assert_member_list(1, "is_other_player", "alice")  # 1人目(alice)に丸がついていない
        assert_member_list(2, "is_current_player", "bob")  # 2人目(bob)は指せるので丸がついている
      end
      b_block do
        assert_move("33", "34", "☖3四歩")                 # 2番目のbobは指せる
        assert_no_text("(通知効果音)")                 # aliceさんの手番なので出ない
        assert_text("次はaliceさんの手番です")
      end
    end
  end

  # cd ~/src/shogi-extend/ && BROWSER_DEBUG=1 rspec ~/src/shogi-extend/spec/system/share_board_spec.rb -e '2人対戦で1人観戦'
  describe "2人対戦で1人観戦" do
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
        side_menu_open
        menu_item_click("順番設定")                        # 「順番設定」モーダルを開く
        find(".main_switch").click                         # 有効スイッチをクリック (最初なので同時に適用を押したの同じで内容も送信)
        order_toggle(3)                                    # 3番目のcarolさんの「OK」をクリックして「観戦」に変更
        first(".apply_button").click                       # 適用クリック
        first(".close_button_for_capybara").click          # 閉じる (ヘッダーに置いている)
      end
      c_block do
        assert_member_list(1, "is_current_player", "alice") # 1人目(alice)に丸がついている
        assert_member_list(2, "is_other_player", "bob")     # 2人目(bob)は待機中
        assert_member_list(3, "is_watching", "carol")       # 3人目(carol)は観戦中
        assert_no_move("77", "76", "☗7六歩")              #  なので3番目のcarolは指せない
      end
      a_block do
        assert_move("77", "76", "☗7六歩")                 # 1番目のaliceが指す
      end
      b_block do
        assert_move("33", "34", "☖3四歩")                 # 2番目のbobが指す
      end
      c_block do
        assert_no_move("27", "26", "☗2六歩")              # 3番目のcarolは観戦者なので指せない
      end
      a_block do
        assert_move("27", "26", "☗2六歩")                 # 1順してaliceが3手目を指す
      end
    end
  end

  # cd ~/src/shogi-extend/ && BROWSER_DEBUG=1 rspec ~/src/shogi-extend/spec/system/share_board_spec.rb -e '順番設定のあと一時的に機能OFFにしたので通知されない'
  describe "順番設定のあと一時的に機能OFFにしたので通知されない" do
    it "works" do
      a_block do
        room_setup("my_room", "alice")                     # aliceが部屋を作る
      end
      b_block do
        room_setup("my_room", "bob")                       # bobも同じ部屋に入る
      end
      a_block do
        order_modal_main_switch_click("有効")              # 順番設定ON
        assert_move("77", "76", "☗7六歩")                 # aliceが指す
      end
      b_block do
        assert_text("(通知効果音)")                        # aliceが指し終わったのでbobに通知
        assert_move("33", "34", "☖3四歩")                 # bobが指す
      end
      a_block do
        assert_text("(通知効果音)")                        # bobがが指し終わったのでaliceに通知
        order_modal_main_switch_click("無効")              # 順番設定OFF
        assert_move("27", "26", "☗2六歩")                 # aliceが指す
      end
      b_block do
        assert_no_text("(通知効果音)")                     # 順番設定OFFなので通知されない
      end
    end

    def order_modal_main_switch_click(stat)
      side_menu_open
      menu_item_click("順番設定")                        # 「順番設定」モーダルを開く
      find(".main_switch").click                         # 有効スイッチをクリック (最初なので同時に適用を押したの同じで内容も送信)
      assert_text("さんが順番設定を#{stat}にしました")   # 有効にしたことが(ActionCable経由で)自分に伝わった
      first(".close_button_for_capybara").click          # 閉じる (ヘッダーに置いている)
    end
  end

  # cd ~/src/shogi-extend/ && BROWSER_DEBUG=1 rspec ~/src/shogi-extend/spec/system/share_board_spec.rb -e 'メッセージ'
  describe "メッセージ" do
    it "works" do
      a_block do
        room_setup("my_room", "alice")                   # aliceが部屋を作る
      end
      b_block do
        room_setup("my_room", "bob")                     # bobも同じ部屋に入る
      end
      a_block do
        find(".message_modal_handle").click              # aliceがメッセージモーダルを開く
        find(".MessageSendModal input").set("(message)") # メッセージ入力
        find(".MessageSendModal .send_button").click     # 送信
        assert_text("(message)")                         # 自分自身にメッセージが届く
      end
      b_block do
        assert_text("(message)")                         # bobにもメッセージが届く
      end
    end
  end

  # cd ~/src/shogi-extend/ && BROWSER_DEBUG=1 rspec ~/src/shogi-extend/spec/system/share_board_spec.rb -e '片方が駒移動中に同期'
  describe "片方が駒移動中に同期" do
    it "works" do
      a_block do
        room_setup("my_room", "alice")    # aliceが部屋を作る
      end
      b_block do
        room_setup("my_room", "bob")      # bobも同じ部屋に入る
      end
      b_block do
        place_click("27")                 # bobさんが手番を間違えて▲26歩しようとして27の歩を持ち上げた
      end
      a_block do
        assert_move("77", "76", "☗7六歩") # そのタイミングでaliceさんが▲76歩と指した
      end
      b_block do                          # bobさんの27クリックはキャンセルされた
        assert_move("33", "34", "☖3四歩") # bobが指す
        piece_move("88", "22")            # bobは2手指しで▲22角成をしようとして確認モーダルが表示されている
      end
      a_block do
        assert_move("27", "26", "☗2六歩") # そのタイミングでaliceさんが▲26歩と指してbobさんの2手指差未遂はキャンセルされた
      end
    end
  end

  # cd ~/src/shogi-extend/ && BROWSER_DEBUG=1 rspec ~/src/shogi-extend/spec/system/share_board_spec.rb -e '局面を戻していても同期されると最後の局面になる'
  describe "局面を戻していても同期されると最後の局面になる" do
    it "works" do
      a_block do
        room_setup("my_room", "alice")                     # aliceが部屋を作る
      end
      b_block do
        room_setup("my_room", "bob")                       # bobも同じ部屋に入る
      end
      a_block do
        assert_move("77", "76", "☗7六歩")                 # aliceが指す
      end
      b_block do
        assert_move("33", "34", "☖3四歩")                 # bobが指す
        sp_controller_click("first")                       # bobは最初の局面に戻した
      end
      a_block do
        assert_move("27", "26", "☗2六歩")                 # aliceが指す
      end
      b_block do
        assert_move("83", "84", "☖8四歩")                 # 最後の局面になっている(bobの手番になっている)のでbobが指せる
      end
    end
  end

  # cd ~/src/shogi-extend/ && BROWSER_DEBUG=1 rspec ~/src/shogi-extend/spec/system/share_board_spec.rb -e '局面再送'
  describe "局面再送" do
    it "同期成功" do
      @RETRY_CHECK_DELAY = 1    # N秒後に返信をチェックする
      a_block do
        visit_with_args(room_code: :my_room, force_user_name: "alice", ordered_member_names: "alice,bob", RETRY_CHECK_DELAY: @RETRY_CHECK_DELAY)
      end
      b_block do
        visit_with_args(room_code: :my_room, force_user_name: "bob", ordered_member_names: "alice,bob")
      end
      a_block do
        assert_move("77", "76", "☗7六歩")                # aliceが指した直後bobから応答OKが0.75秒ぐらいで帰ってくる
        sleep(@RETRY_CHECK_DELAY)                         # なので1秒待って alice 側はチェックする
        assert_no_text("同期失敗")                        # 同期OKになっているので「同期失敗」ダイアログは出ない
      end
    end
    it "同期失敗" do
      # RETRY_CHECK_DELAY を 0 にすることで返信前にチェックしてしまうので失敗ダイアログが出る
      a_block do
        visit_with_args(room_code: :my_room, force_user_name: "alice", ordered_member_names: "alice,bob", RETRY_CHECK_DELAY: 0)
      end
      b_block do
        visit_with_args(room_code: :my_room, force_user_name: "bob", ordered_member_names: "alice,bob")
      end
      a_block do
        assert_move("77", "76", "☗7六歩")                 # aliceが指した直後bobから応答OKが0.75秒ぐらいで帰ってくる
        assert_text("同期失敗")                            # しかし 0.75 秒待つ前にチェックしているため同期失敗となる
        assert_text("次の手番のbobさんの反応がないため再送しますか？")

        click_text_match("再送する")                       # 再送するがまたすぐにチェックしているので
        assert_text("同期失敗")                            # 同期失敗となる

        doc_image
      end
    end
  end

  # cd ~/src/shogi-extend/ && BROWSER_DEBUG=1 rspec ~/src/shogi-extend/spec/system/share_board_spec.rb -e '自分の盤を全員に反映'
  describe "自分の盤を全員に反映" do
    it "works" do
      a_block do
        room_setup("my_room", "alice")                    # aliceが部屋を作る
      end
      b_block do
        room_setup("my_room", "bob")                      # bobも同じ部屋に入る
      end
      a_block do
        assert_move("77", "76", "☗7六歩")                 # 1手目
      end
      b_block do
        assert_move("33", "34", "☖3四歩")                 # 2手目
      end
      a_block do
        assert_move("27", "26", "☗2六歩")                 # 3手目
      end
      b_block do
        assert_move("83", "84", "☖8四歩")                 # 4手目
      end
      a_block do
        sp_controller_click("previous")                   # 3手戻す
        sp_controller_click("previous")
        sp_controller_click("previous")

        side_menu_open
        menu_item_click("自分の盤を全員に反映") # モーダルを開く
        first(".sync_button").click                       # 反映する
      end
      b_block do
        assert_move("33", "34", "☖3四歩")                 # aliceが局面を戻したので再びbobは2手目を指せる
      end
    end
  end

  # cd ~/src/shogi-extend/ && BROWSER_DEBUG=1 rspec ~/src/shogi-extend/spec/system/share_board_spec.rb -e '再接続'
  describe "再接続" do
    it "先輩であっても再接続したら後輩になる" do
      a_block do
        room_setup("my_room", "alice")                    # alice先輩が部屋を作る
        assert_member_list(1, "is_joined", "alice")       # 一番上にaliceがいる
        sleep(2)                                          # 先輩後輩は最低1秒毎の差なので2秒待てば確実にbobは後輩になる
      end
      b_block do
        room_setup("my_room", "bob")                      # bob後輩が同じ部屋に入る
        assert_member_list(2, "is_joined", "bob")         # 最後に追加される
        sleep(2)                                          # これでbobをレベル2ぐらいにはなる(aliceはレベル4)
      end
      a_block do
        assert_move("77", "76", "☗7六歩")                # aliceが指してbobの盤も同じになる
        sp_controller_click("first")                      # 再接続時にbobから受けとったか確認しやすいように0手目にしておく

        room_recreate_apply                               # 再接続実行
        assert_turn_offset(1)                             # bobからもらったので1手目になっている
        assert_member_list(1, "is_joined", "bob")         # 並びは後輩だったbobが先輩に
        assert_member_list(2, "is_joined", "alice")       # 先輩だったaliceは後輩になっている
      end
    end
  end

  # cd ~/src/shogi-extend/ && BROWSER_DEBUG=1 rspec ~/src/shogi-extend/spec/system/share_board_spec.rb -e 'PING'
  describe "PING" do
    it "成功" do
      a_block do
        room_setup("my_room", "alice")                    # alice先輩が部屋を作る
      end
      b_block do
        room_setup("my_room", "bob")                      # bob後輩が同じ部屋に入る
      end
      a_block do
        member_list_click(2)
        assert_text("bobさんの反応速度は")
      end
    end
    it "失敗" do
      @PING_OK_SEC = 3 # N秒以内ならPINGを成功とみなす
      @PONG_DELAY  = 5 # PONGするまでの秒数(デバッグ時には PING_OK_SEC 以上の値にする)
      a_block do
        visit_with_args(room_code: :my_room, force_user_name: "alice", PING_OK_SEC: @PING_OK_SEC)
      end
      b_block do
        visit_with_args(room_code: :my_room, force_user_name: "bob", PONG_DELAY: @PONG_DELAY)
      end
      a_block do
        # debugger
        member_list_click(2)    # 1回押し
        member_list_click(2)    # 続けて押すと
        assert_text("PING実行中...")
        assert_text("bobさんの反応がありません")
      end
    end
  end

  def visit_with_args(args)
    visit "/share-board?#{args.to_query}"
  end

  def room_setup(room_code, user_name)
    visit "/share-board"
    side_menu_open
    menu_item_click("合言葉の設定と共有")        # 「合言葉の設定と共有」を自分でクリックする
    first(".new_room_code input").set(room_code) # 合言葉を入力する
    first(".new_user_name input").set(user_name) # ハンドルネームを入力する
    first(".share_button").click                 # 共有ボタンをクリックする
    assert_text(user_name)                       # 入力したハンドルネームの人が参加している
  end

  def chess_clock_set(initial_main_min, initial_read_sec, initial_extra_sec, every_plus)
    find(".initial_main_min input").set(initial_main_min)   # 持ち時間(分)
    find(".initial_read_sec input").set(initial_read_sec)   # 秒読み
    find(".initial_extra_sec input").set(initial_extra_sec) # 猶予(秒)
    find(".every_plus input").set(every_plus)               # 1手毎加算(秒)
  end

  def assert_clock_active_black
    assert_selector(".is_black .is_sclock_active")
    assert_selector(".is_white .is_sclock_inactive")
  end

  def assert_clock_active_white
    assert_selector(".is_black .is_sclock_inactive")
    assert_selector(".is_white .is_sclock_active")
  end

  def assert_move(from, to, human)
    piece_move(from, to)
    Capybara.using_wait_time(10) do
      assert_text(human)
    end
  end

  def assert_no_move(from, to, human)
    piece_move(from, to)
    Capybara.using_wait_time(10) do
      assert_no_text(human)
    end
  end

  def piece_move(from, to)
    [from, to].each { |e| place_click(e) }
  end

  # place_click("76") は find(".place_7_6").click 相当
  def place_click(place)
    find([".place", place.chars].join("_")).click #
  end

  # OK or 観戦 トグルボタンのクリック
  def order_toggle(n)
    find(".OrderSettingModal table tr:nth-child(#{n}) .enable_toggle_handle").click
  end

  def assert_white_read_sec(second)
    v = find(".is_white .read_sec").text.to_i
    assert { v == second || v == second.pred }
  end

  def assert_clock_on
    assert_selector(".MembershipLocationPlayerInfo")
  end

  def assert_clock_off
    assert_no_selector(".MembershipLocationPlayerInfoTime")
  end

  # メンバーリストの上からi番目の状態と名前
  def assert_member_list(i, klass, user_name)
    Capybara.within(".ShareBoardMemberList") do
      # 手番・手番待ち・観戦者のどれか確認
      assert_selector(".member_info:nth-child(#{i}).#{klass}")

      # 名前の確認
      text = find(".member_info:nth-child(#{i}).#{klass} .user_name").text
      assert { text === user_name }
    end
  end

  def member_list_click(i)
    find(".ShareBoardMemberList .member_info:nth-child(#{i})").click
  end

  def sp_controller_click(klass)
    find(".ShogiPlayer .NavigateBlock .button.#{klass}").click
  end

  def room_recreate_apply
    side_menu_open
    menu_item_click("再接続 (なんかおかしいとき用)")  # モーダルを開く
    first(".apply_button").click                      # 実行する
  end

  def side_menu_open
    find(".sidebar_toggle_navbar_item").click
  end

  def assert_turn_offset(turn_offset)
    assert_text("##{turn_offset}")
  end
end
