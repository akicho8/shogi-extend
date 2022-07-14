require "#{__dir__}/shared_methods"

RSpec.describe "共有将棋盤", type: :system, share_board_spec: true do
  include SharedMethods

  before do
    XmatchRuleInfo.clear_all    # 重要
  end

  it "視点はselfなので駒落ちのときに△側が下に来ている" do
    a_block do
      visit "/share-board?abstract_viewpoint=self&body=position+sfen+4k4%2F9%2F9%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+w+-+1&turn=0"
      assert_viewpoint(:white)
      doc_image
    end
  end

  it "合言葉を含むURLから来てハンドルネーム入力して接続して駒を動かす" do
    a_block do
      visit "/share-board?room_code=my_room"     # 合言葉を含むURLから来る
      assert_selector(".RoomSetupModal")     # 「部屋に入る」のモーダルが自動的に表示されている
      Capybara.within(".RoomSetupModal") do
        assert_text("部屋に入る")                # 「部屋に入る」のモーダルのタイトルも正しい
        find(".new_user_name input").set("alice") # ハンドルネームを入力する
        find(".entry_button").click               # 共有ボタンをクリックする
        find(".close_handle").click               # 閉じる
      end
      assert_text("alice")                       # 入力したハンドルネームの人がメンバーリストに表示されている
      piece_move_o("77", "76", "☗7六歩")
      doc_image
    end
  end

  it "順番設定OFF状態で共有" do
    a_block do
      room_setup("my_room", "alice")
      piece_move_o("17", "16", "☗1六歩")                      # aliceは一人で初手を指した
    end
    b_block do
      room_setup("my_room", "bob")                            # alice と同じ部屋の合言葉を設定する
      assert_member_exist("alice")
      assert_member_exist("bob")
      doc_image("bobはaliceの盤面を貰った")                   # この時点で▲16歩が共有されている
    end
    a_block do
      assert_member_exist("alice")
      assert_member_exist("bob")
    end
    b_block do
      piece_move_o("33", "34", "☖3四歩")                      # bobは2手目の後手を指せる
    end
    a_block do
      assert_text("☖3四歩")                                    # aliceの画面にもbobの指し手の符号が表示されている
      doc_image("aliceとbobは画面を共有している")
    end
  end

  describe "対局時計基本" do
    before do
      @INITIAL_SEC = 5
    end

    it "works" do
      a_block do
        room_setup("my_room", "alice")             # aliceが部屋を作る
      end
      b_block do
        room_setup("my_room", "bob")               # bobも同じ部屋に入る
      end
      a_block do
        clock_open
      end
      b_block do
        assert_clock_on                            # 同期してbob側にも設置されている
      end
      a_block do
        clock_box_set(0, @INITIAL_SEC, 0, 0) # aliceが時計を設定する
        find(:button, :class => "play_button").click                     # 開始
        find(:button, :text => "無視して開始する", exact_text: true).click
        modal_close_handle  # 閉じる (ヘッダーに置いている)
      end
      b_block do
        assert_white_read_sec(@INITIAL_SEC)    # bob側は秒読みが満タン
      end
      a_block do
        piece_move_o("27", "26", "☗2六歩")         # 初手を指す
        assert_clock_active_white                  # 時計を同時に押したので後手がアクティブになる
      end
      b_block do
        assert_clock_active_white                  # bob側も後手がアクティブになっている
        sleep(@INITIAL_SEC)                    # ここでは3秒ぐらいになってるけどさらに秒読みぶん待つ
        assert_white_read_sec(0)                   # 秒読みが0になっている
        assert_text("時間切れで☗の勝ち！")         # 時間切れのダイアログの表示(1回目)
        find(".button.is-primary").click           # それを閉じる
      end
      a_block do
        assert_text("時間切れで☗の勝ち！")         # alice側でも時間切れのダイアログが表示されている
        find(".button.is-primary").click           # それを閉じる
      end
      b_block do
        piece_move_o("33", "34", "☖3四歩")          # bobは時間切れになったがそれを無視して指した
        assert_white_read_sec(@INITIAL_SEC)    # すると秒読みが復活した
        assert_clock_active_black                  # 時計も相手に切り替わった
      end
      a_block do
        assert_clock_active_black                  # alice側もaliceがアクティブになった
        assert_white_read_sec(@INITIAL_SEC)    # bobの秒読みが復活している
        piece_move_o("77", "76", "☗7六歩")          # aliceは3手目を指した
        assert_clock_active_white                  # bobに時計が切り替わった
      end
      b_block do
        assert_clock_active_white                  # bob側もbob側にの時計に切り替わった
        sleep(@INITIAL_SEC)                    # bobは再び時間切れになるまで待った
        assert_white_read_sec(0)                   # また0時間切れになった
        assert_text("時間切れで☗の勝ち！")         # 2度目のダイアログが出た
      end
      a_block do
        assert_text("時間切れで☗の勝ち！")         # alice側でもダイアログが出た
      end
    end
  end

  describe "順番設定で手番お知らせ" do
    it "works" do
      a_block do
        room_setup("my_room", "alice")                     # aliceが部屋を作る
      end
      b_block do
        room_setup("my_room", "bob")                       # bobも同じ部屋に入る
        hamburger_click
        os_modal_handle                        # 「順番設定」モーダルを開く (まだ無効の状態)
      end
      a_block do
        hamburger_click
        os_modal_handle                        # 「順番設定」モーダルを開く
        find(".main_switch").click                         # 有効スイッチをクリック (最初なので同時に適用を押したの同じで内容も送信)
        action_assert(0, "alice", "順番 ON")               # aliceが有効にしたことが(ActionCable経由で)自分に伝わった
        modal_close_handle          # 閉じる (ヘッダーに置いている)
      end
      b_block do
        action_assert(0, "alice", "順番 ON")
        assert_selector(".OrderSettingModalTable")         # 同期しているのでbob側のモーダルも有効になっている
        modal_close_handle          # 閉じる (ヘッダーに置いている)
        assert_member_list(1, "is_turn_active", "alice")   # 1人目(alice)に丸がついている
        assert_member_list(2, "is_turn_standby", "bob")    # 2人目(bob)は待機中
        piece_move_x("77", "76", "☗7六歩")              # なので2番目のbobは指せない
      end
      a_block do
        assert_member_list(1, "is_turn_active", "alice")   # 1人目(alice)に丸がついている
        assert_member_list(2, "is_turn_standby", "bob")    # 2人目(bob)は待機中
        piece_move_o("77", "76", "☗7六歩")                 # aliceが1番目なので指せる
      end
      b_block do
        assert_system_variables(:tn_counter, 1)            # bobさんだけに牛が知らせている
      end
      a_block do
        assert_text("次は、bobさんの手番です")
        piece_move_x("33", "34", "☖3四歩")              # aliceもう指したので指せない
        assert_member_list(1, "is_turn_standby", "alice")  # 1人目(alice)に丸がついていない
        assert_member_list(2, "is_turn_active", "bob")     # 2人目(bob)は指せるので丸がついている
      end
      b_block do
        piece_move_o("33", "34", "☖3四歩")                 # 2番目のbobは指せる
        assert_system_variables(:tn_counter, 1)            # aliceさんの手番なので出ない(変化せず)
        assert_text("次は、aliceさんの手番です")
      end
    end
  end

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
        hamburger_click
        os_modal_handle                        # 「順番設定」モーダルを開く
        find(".main_switch").click                         # 有効スイッチをクリック (最初なので同時に適用を押したの同じで内容も送信)
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

  describe "順番設定のあと一時的に機能OFFにしたので通知されない" do
    it "works" do
      a_block do
        room_setup("my_room", "alice")    # aliceが部屋を作る
      end
      b_block do
        room_setup("my_room", "bob")      # bobも同じ部屋に入る
      end
      a_block do
        order_set_on                      # 順番設定ON
        piece_move_o("77", "76", "☗7六歩") # aliceが指す
      end
      b_block do
        assert_system_variables(:tn_counter, 1) # aliceが指し終わったのでaliceに通知
        piece_move_o("33", "34", "☖3四歩") # bobが指す
      end
      a_block do
        assert_system_variables(:tn_counter, 1) # bobが指し終わったのでaliceに通知
        order_set_off                     # 順番設定OFF
        piece_move_o("27", "26", "☗2六歩") # aliceが指す
      end
      b_block do
        assert_system_variables(:tn_counter, 1) # 順番設定OFFなので通知されずカウンタは進んでいない
      end
    end
  end

  describe "メッセージ" do
    it "works" do
      message1 = SecureRandom.hex
      a_block do
        room_setup("my_room", "alice")                   # aliceが部屋を作る
      end
      b_block do
        room_setup("my_room", "bob")                     # bobも同じ部屋に入る
      end
      a_block do
        find(".message_modal_handle").click              # aliceがメッセージモーダルを開く
        find(".MessageSendModal input").set(message1)    # メッセージ入力
        find(".MessageSendModal .send_handle").click     # 送信
        assert_text(message1)                            # 自分自身にメッセージが届く
      end
      b_block do
        assert_text(message1)                           # bobにもメッセージが届く
      end
    end

    it "観戦者宛送信" do
      a_block { visit_app(room_code: :my_room, force_user_name: "alice", ordered_member_names: "alice", autoexec: "message_modal_handle") }
      b_block { visit_app(room_code: :my_room, force_user_name: "bob",   ordered_member_names: "alice", autoexec: "message_modal_handle") }
      c_block { visit_app(room_code: :my_room, force_user_name: "carol", ordered_member_names: "alice", autoexec: "message_modal_handle") }

      message1 = SecureRandom.hex
      b_block { message_send(:is_message_scope_private, message1) }   # 観戦者の bob が観戦者送信した
      b_block { assert_text(message1)              }   # 自分には (観戦者かに関係なく本人だから) 届いている
      a_block { assert_no_text(message1)           }   # alice には対局者なので届いていない
      c_block { assert_text(message1)              }   # carol には観戦者なので届いている

      message2 = SecureRandom.hex
      a_block { message_send(:is_message_scope_private, message2) }   # 対局者の alice が送信した
      a_block { assert_text(message2)              }   # 自分には (観戦者かに関係なく本人だから) 届いている
      b_block { assert_text(message2)              }   # bob   には観戦者なので届いている
      c_block { assert_text(message2)              }   # carol には観戦者なので届いている

      b_block do
        find(".MessageSendModal .close_handle").click  # メッセージモーダルを閉じる
        order_set_off          # 順番設定を解除する
      end

      # bobが順番設定を解除したことで
      a_block do
        assert_text(message1)                                         # bob の送信を alice は見えるようになった
        assert_no_selector(".MessageSendModal .message_scope_dropdown") # 順番設定を解除したためスコープ選択は表示されていない
      end
    end

    it "順番設定していたら観戦者がいなくてもスコープ選択ドロップダウンが出ている" do
      a_block do
        visit_app(room_code: :my_room, force_user_name: "alice", ordered_member_names: "alice", autoexec: "message_modal_handle")
        assert_selector(".MessageSendModal .message_scope_dropdown")
      end
    end

    it "Enterで送信する" do
      a_block do
        visit_app(room_code: :my_room, force_user_name: "alice", ordered_member_names: "alice", autoexec: "message_modal_handle")
        message1 = SecureRandom.hex
        find(".MessageSendModal input").set(message1)
        find(".MessageSendModal input").send_keys("\n") # ENTER
        assert_text(message1)
      end
    end
  end

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
        piece_move_o("77", "76", "☗7六歩") # そのタイミングでaliceさんが▲76歩と指した
      end
      b_block do                          # bobさんの27クリックはキャンセルされた
        piece_move_o("33", "34", "☖3四歩") # bobが指す
        piece_move("88", "22")            # bobは2手指しで▲22角成をしようとして確認モーダルが表示されている
      end
      a_block do
        piece_move_o("27", "26", "☗2六歩") # そのタイミングでaliceさんが▲26歩と指してbobさんの2手指差未遂はキャンセルされた
      end
    end
  end

  describe "局面を戻していても同期されると最後の局面になる" do
    it "works" do
      a_block do
        room_setup("my_room", "alice")                     # aliceが部屋を作る
      end
      b_block do
        room_setup("my_room", "bob")                       # bobも同じ部屋に入る
      end
      a_block do
        piece_move_o("77", "76", "☗7六歩")                 # aliceが指す
      end
      b_block do
        piece_move_o("33", "34", "☖3四歩")                 # bobが指す
        sp_controller_click("first")                       # bobは最初の局面に戻した
      end
      a_block do
        piece_move_o("27", "26", "☗2六歩")                 # aliceが指す
      end
      b_block do
        piece_move_o("83", "84", "☖8四歩")                 # 最後の局面になっている(bobの手番になっている)のでbobが指せる
      end
    end
  end

  describe "局面の転送" do
    it "works" do
      a_block do
        room_setup("my_room", "alice")                    # aliceが部屋を作る
      end
      b_block do
        room_setup("my_room", "bob")                      # bobも同じ部屋に入る
      end
      a_block do
        piece_move_o("77", "76", "☗7六歩")                 # 1手目
      end
      b_block do
        piece_move_o("33", "34", "☖3四歩")                 # 2手目
      end
      a_block do
        piece_move_o("27", "26", "☗2六歩")                 # 3手目
      end
      b_block do
        piece_move_o("83", "84", "☖8四歩")                 # 4手目
      end
      a_block do
        sp_controller_click("previous")                   # 3手戻す
        sp_controller_click("previous")
        sp_controller_click("previous")
        assert_turn(1)

        hamburger_click
        menu_item_click2("局面の転送")           # モーダルを開く
        find(:button, text: "転送する", exact_text: true).click   # 反映する
      end
      b_block do
        assert_turn(1)                             # bobの局面が戻っている
      end
    end
  end

  describe "再起動" do
    it "先輩であっても再起動したら後輩になる" do
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
      b_block do
        piece_move_o("77", "76", "☗7六歩")                # aliceが指してbobの盤も同じになる
        sp_controller_click("first")                      # 再起動時にbobから受けとったか確認しやすいように0手目にしておく
        assert_turn(0)
      end
      a_block do
        room_recreate_apply                               # 再起動実行
        assert_turn(0)                                    # bobから0手目をもらった
        assert_member_list(1, "is_joined", "bob")         # 並びは後輩だったbobが先輩に
        assert_member_list(2, "is_joined", "alice")       # 先輩だったaliceは後輩になっている
      end
    end
  end

  describe "メンバー情報" do
    it "works" do
      a_block do
        room_setup("my_room", "alice")
        member_list_click_nth(1)
        assert_text("通信状況")
        doc_image
      end
    end
  end

  describe "バージョンチェック" do
    it "最新" do
      @API_VERSION = ShareBoardControllerMethods::API_VERSION
      a_block do
        visit_app(room_code: :my_room, force_user_name: "alice", API_VERSION: @API_VERSION)
        assert_no_text("新しいプログラムがあるのでブラウザをリロードします")
      end
    end
    it "更新" do
      @API_VERSION = ShareBoardControllerMethods::API_VERSION + 1
      a_block do
        visit_app(room_code: :my_room, force_user_name: "alice", API_VERSION: @API_VERSION)
        assert_text("新しいプログラムがあるのでブラウザをリロードします")
        doc_image
        buefy_dialog_button_click
      end
    end
  end

  describe "初期配置に戻す" do
    it "正しく同期する" do
      a_block do
        room_setup("my_room", "alice")                    # alice先輩が部屋を作る
      end
      b_block do
        room_setup("my_room", "bob")                      # bob後輩が同じ部屋に入る
      end
      a_block do
        piece_move_o("77", "76", "☗7六歩")                # aliceが指す
        assert_turn(1)                             # 1手進んでいる
      end
      b_block do
        assert_turn(1)                             # bob側も1手進んでいる
      end
      a_block do
        hamburger_click
        menu_item_click("初期配置に戻す")                 # 「初期配置に戻す」モーダルを開く
        find(".apply_button").click                       # 「N手目まで戻る」
        # buefy_dialog_button_click(".is-danger")           # 「本当に実行」クリック
        assert_turn(0)                             # 0手に戻っている
      end
      b_block do
        assert_turn(0)                             # bob側も0手に戻っている
      end
    end

    it "初期配置に戻すダイアログの中で局面を調整する" do
      a_block do
        room_setup("my_room", "alice")                    # alice先輩が部屋を作る
        piece_move_o("77", "76", "☗7六歩")                # aliceが指す
        assert_turn(1)                                    # 1手進んでいる
        hamburger_click
        menu_item_click("初期配置に戻す")                 # 「初期配置に戻す」モーダルを開く
        Capybara.within(".TurnChangeModal") do
          assert_text("局面 #0")                          # 初期配置に戻すため初期値は0手目になっているが
          find(".button.next").click                      # 「>」で
          assert_text("局面 #1")                          # 1手目に進める
        end
        find(".apply_button").click                       # 「N手目まで戻る」
        assert_turn(1)                                    # 0手目ではなく1手目に戻っている
      end
    end
  end

  describe "1手戻す" do
    it "正しく同期する" do
      a_block do
        room_setup("my_room", "alice")                    # alice先輩が部屋を作る
      end
      b_block do
        room_setup("my_room", "bob")                      # bob後輩が同じ部屋に入る
      end
      a_block do
        piece_move_o("77", "76", "☗7六歩")                # aliceが指す
      end
      b_block do
        piece_move_o("33", "34", "☖3四歩")                # bobが指す
      end
      a_block do
        hamburger_click
        menu_item_click("1手戻す")                        # 「1手戻す」モーダルを開く
        find(".apply_button").click                       # 「N手目まで戻る」
        # buefy_dialog_button_click(".is-danger")           # 「本当に実行」クリック
        assert_turn(1)                             # 1手目に戻っている
      end
      b_block do
        assert_turn(1)                             # bob側も1手に戻っている
      end
    end
  end

  describe "不正なSFEN" do
    it "意図したエラー画面が出ている" do
      visit("/share-board?body=position%20sfen%20lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL%20b%20%201%20moves%202g2f%203c3d%207g7f%204c4d%206g6f%203a4b%202f2e%204b3c%204i5h%204a3b%206i7h%208c8d%207i6h%207a6b%203i4h%206a5b%205i6i%205c5d%206h6g%202b3a%205g5f%208d8e%204h5g%205a6a%205f5e%205d5e%206f6e%208e8f%208g8f%203a8f%208h6f%208f3a%20P%2a8g%206b5c%208i7g%206a5a%203g3f%205c5d%205g4f%205a4a%203f3e%203d3e%204f3e%205b4c%202e2d%203c2d%203e2d%202c2d%202h2d%20P%2a2c%202d2f%201c1d%201g1f%20P%2a8f%208g8f%208b8f%20P%2a8g%208f8b%202i3g%20S%2a3e%202f2e%204c3d%202e2i%20P%2a3f%203g2e%202c2d%20P%2a3c%202a3c%202e3c%2B%203d3c")
      assert_text("入力のSFEN形式が不正確です")
    end
  end

  describe "退室するとメンバー一覧から即削除" do
    it "works" do
      a_block do
        room_setup("my_room", "alice") # aliceが部屋を作る
      end
      b_block do
        room_setup("my_room", "bob")   # bobも同じ部屋に入る
        assert_member_exist("alice")   # alice がいる
        assert_member_exist("bob")     # bob もいる
      end
      a_block do
        assert_member_exist("alice")   # alice の部屋にも alice と
        assert_member_exist("bob")     # bob がいる
        room_leave                     # 退室
      end
      b_block do
        assert_member_missing("alice") # bob 側の alice が即座に消えた
        assert_member_exist("bob")     # bob は、おる
      end
    end
  end

  describe "対局時計初期値永続化" do
    it "works" do
      @CLOCK_VALUES = [1, 2, 3, 4]

      visit "/share-board"

      clock_open
      clock_box_set(*@CLOCK_VALUES)     # aliceが時計を設定する
      find(".play_button").click        # 開始 (このタイミングで初期値として保存する)

      visit(current_path)               # リロード
      clock_open
      clock_box_values_eq @CLOCK_VALUES # 時計の初期値が復帰している
    end
  end

  describe "使い方" do
    it "モーダルで開く" do
      visit "/share-board"
      hamburger_click
      menu_item_click("使い方")
      find(".close_handle").click
    end

    it "モーダルからパーマリンクで飛ぶ" do
      visit "/share-board"
      hamburger_click
      menu_item_click("使い方")
      find(".permalink").click       # 固定URLを別タブで開く
      switch_to_window_last # 別タブに移動する
      assert_current_path "/share-board/help", ignore_query: true
    end

    it "ほぼ静的ページ" do
      visit "/share-board/help"
      assert_text("リレー将棋")
    end
  end

  describe "手合割" do
    it "works" do
      a_block do
        room_setup("my_room", "alice") # aliceが部屋を作る
      end
      b_block do
        room_setup("my_room", "bob")   # bobも同じ部屋に入る
      end
      a_block do
        preset_select("香落ち")
      end
      b_block do
        piece_move_o("22", "11", "☖1一角")
      end
    end
  end

  describe "時計の初回PLAYで手番の人を示す" do
    it "works" do
      a_block do
        room_setup("my_room", "alice")               # aliceが部屋を作る
      end
      b_block do
        room_setup("my_room", "bob")                 # bobも同じ部屋に入る
      end
      b_block do
        order_set_on                                 # 順番設定ON
        clock_start                                  # 対局時計 PLAY
      end
      a_block do
        assert_text("aliceから開始をaliceだけに通知") # 最初はaliceさんから開始
      end
      b_block do
        assert_text("aliceさんから開始してください") # bobさんの方でも誰から開始するかが示された
        doc_image
      end
    end
  end

  describe "「順番設定有効→退室→指す」では退室しているので再送は発動しない" do
    it "works" do
      @RETRY_DELAY = 3
      a_block do
        visit_app(room_code: :my_room, force_user_name: "alice", ordered_member_names: "alice", RETRY_DELAY: @RETRY_DELAY)
        room_leave
        piece_move("77", "76")
        sleep(@RETRY_DELAY)
        assert_no_text("同期失敗")
      end
    end
  end

  describe "時計開始時に視点の自動設定" do
    def case1(preset_key)
      a_block do
        room_setup("my_room", "alice") # aliceが部屋を作る
      end
      b_block do
        room_setup("my_room", "bob")   # bobも同じ部屋に入る
      end
      a_block do
        preset_select(preset_key)      # 手合割設定
        order_set_on                   # 順番設定ON
        clock_start                    # 対局時計PLAY
      end
    end
    it "平手" do
      case1("平手")
      a_block do
        assert_viewpoint(:black) # bob が▲なので盤が反転していない
      end
      b_block do
        assert_viewpoint(:white) # alice が△なので盤が反転している
      end
    end
    it "駒落ち" do
      case1("八枚落ち")
      a_block do
        assert_viewpoint(:white) # bob が△なので盤が反転している
      end
      b_block do
        assert_viewpoint(:black) # alice が▲なので盤が反転している
      end
    end
  end

  describe "順番設定で更新を押さないで閉じたら確認する" do
    it "works" do
      a_block do
        visit_app(room_code: :my_room, force_user_name: "alice")
        hamburger_click
        os_modal_handle               # 「順番設定」モーダルを開く
        find(".main_switch").click                # 右上の有効スイッチをクリック
        find(".shuffle_handle").click             # シャッフルする
        modal_close_handle                         # 閉じる (ヘッダーに置いている) とするがダイアログが表示される
        click_text_match("更新せずに閉じる")      # 無視して閉じる
      end
    end
  end

  describe "順番設定の振り駒" do
    def case1(shakashaka_count, piece_names, message)
      a_block do
        visit_app({
            :room_code                 => :my_room,
            :force_user_name           => "1",
            :ordered_member_names      => "1,2,3,4",
            :handle_name_validate_skip => "true",
            :furigoma_random_key       => "is_true",        # 毎回反転が起きる
            :shakashaka_count          => shakashaka_count, # 2回すると反転の反転で表に戻る(つまり「歩」が5枚)
          })

        hamburger_click
        os_modal_handle                       # 「順番設定」モーダルを開く(すでに有効になっている)

        assert_order_setting_members ["1", "2", "3", "4"]

        find(".furigoma_handle").click
        assert_text(piece_names)
        assert_text(message)
      end
    end

    it "歩5枚" do
      case1("2", "歩歩歩歩歩", "1さんが振り駒をした結果、歩が5枚で1さんの先手になりました")
    end
    it "と金5枚" do
      case1("3", "ととととと", "1さんが振り駒をした結果、と金が5枚で2さんの先手になりました")
    end
  end

  describe "順番設定の先後入替" do
    it "works" do
      a_block do
        visit_app(room_code: :my_room, force_user_name: "1", ordered_member_names: "1,2,3,4", handle_name_validate_skip: "true")

        hamburger_click
        os_modal_handle                       # 「順番設定」モーダルを開く(すでに有効になっている)

        assert_order_setting_members ["1", "2", "3", "4"]

        find(".swap_handle").click                        # 先後入替
        assert_text("1さんが先後を入れ替えました")
        assert_order_setting_members ["2", "1", "4", "3"] # 2つづつswapしていく
      end
    end
  end

  describe "N手毎交代" do
    def case1(hand_every_n, order)
      visit_app(hand_every_n: hand_every_n, room_code: :my_room, force_user_name: "a", ordered_member_names: "a,b,c", handle_name_validate_skip: "true")
      assert_text("順序:#{order}")
    end
    it "works" do
      case1(1, "abcabcabcab")
      case1(2, "ababcacabcb")
      case1(3, "abababcacac")
    end
  end

  describe "持ち上げ駒キャンセル方法" do
    def case1(selector)
      visit_app(room_code: :my_room, force_user_name: "alice")

      hamburger_click
      menu_item_click("設定")               # モーダルを開く
      find(selector).click
      find(".close_handle").click           # 閉じる

      place_click("77")                     # 77を持って
      place_click("87")                     # 87をクリック
    end

    it "移動元をクリック" do
      case1(".is_move_cancel_reality")
      piece_move_x("27", "26", "☗2六歩")  # キャンセルされていないので別の手が指せない
    end

    it "他のセルをクリック" do
      case1(".is_move_cancel_standard")         # 「他のセルをクリック」選択
      piece_move_o("27", "26", "☗2六歩")    # キャンセルされたので別の手が指せる
    end
  end

  describe "自動マッチング" do
    it "飛vs角を1vs1" do
      a_block do
        visit_app(force_user_name: "alice", xmatch_auth_key: "handle_name_required")
      end
      b_block do
        visit_app(force_user_name: "bob", xmatch_auth_key: "handle_name_required")
      end
      a_block do
        hamburger_click
        menu_item_click("自動マッチング")                # モーダルを開く
      end
      b_block do
        hamburger_click
        menu_item_click("自動マッチング")                # モーダルを開く
      end
      a_block do
        find(".rule_1vs1_05_00_00_5_pRvsB").click         # 飛vs角を選択
      end
      b_block do
        find(".rule_1vs1_05_00_00_5_pRvsB").click         # 飛vs角を選択 (ここでマッチング成立)
      end

      # 開発環境では performed_at で並び換えているので必ず alice, bob の順になる
      # app/models/xmatch_rule_info.rb
      a_block do
        assert_viewpoint(:black)                         # alice, bob の順で alice は先手なので▲の向きになっている
        assert_member_list(1, "is_turn_active", "alice") # 1人目(alice)に丸がついている
        assert_member_list(2, "is_turn_standby", "bob")  # 2人目(bob)は待機中
      end
      b_block do
        assert_viewpoint(:white)                         # alice, bob の順で bob は後手なので△の向きになっている
        assert_member_list(1, "is_turn_active", "alice") # 1人目(alice)に丸がついている
        assert_member_list(2, "is_turn_standby", "bob")  # 2人目(bob)は待機中
      end
    end

    it "自分vs自分 平手" do
      a_block do
        visit_app(force_user_name: "alice", xmatch_auth_key: "handle_name_required")

        hamburger_click
        menu_item_click("自動マッチング")          # モーダルを開く
        find(".rule_self_05_00_00_5").click         # 自分vs自分

        assert_viewpoint(:black)                         # 平手の初手なので▲視点
        assert_member_list(1, "is_turn_active", "alice") # 1人目(alice)に丸がついている
      end
    end

    it "時間切れ" do
      @xmatch_wait_max = 2
      a_block do
        visit_app(force_user_name: "alice", xmatch_wait_max: @xmatch_wait_max, xmatch_auth_key: "handle_name_required")

        hamburger_click
        menu_item_click("自動マッチング")          # モーダルを開く
        find(".rule_1vs1_05_00_00_5_pRvsB").click   # 飛vs角を選択

        sleep(@xmatch_wait_max)
        assert_text("時間内に集まらなかった")
      end
    end

    it "ログイン必須モード" do
      a_block do
        logout                                                 # ログアウト状態にする
        visit_app(xmatch_auth_key: "login_required")           # 来る
        xmatch_select_1vs1                                     # 1vs1のルールを選択
        assert_selector(".NuxtLoginContainer")                 # 「ログインしてください」が発動
      end
    end

    it "ハンドルネーム必須モード" do
      a_block do
        logout                                                 # ログアウト状態にする
        visit_app(xmatch_auth_key: "handle_name_required")     # 来る
        xmatch_select_1vs1                                     # 1vs1のルールを選択
        assert_selector(".HandleNameModal")                    # ハンドルネームを入力するように言われる
        find(".HandleNameModal input").set("alice")            # 入力して
        find(".save_handle").click                             # 保存 (success_callback で 1vs1 を選択している)
        assert_selector(".is_entry_active")                    # エントリーできた
      end
    end
  end

  describe "シングルトン時間切れ" do
    before do
      @initial_read_sec = 5         # 5秒切れ負け
      @CC_TIME_LIMIT_BC_DELAY = 0 # 当事者はN秒待って他者たちに時間切れをBCする (ネット遅延のシミューレート)
      @CC_AUTO_TIME_LIMIT_DELAY = 3 # 通知が来なくてもN秒後に自力で時間切れモーダルを表示
    end

    def case1(force_user_name)
      visit_app({
          "room_code"                => "my_room",
          "force_user_name"          => force_user_name,
          "ordered_member_names"     => "alice,bob",
          "RETRY_DELAY"              => -1,
          "CC_AUTO_TIME_LIMIT_DELAY" => @CC_AUTO_TIME_LIMIT_DELAY,
          "CC_TIME_LIMIT_BC_DELAY" => @CC_TIME_LIMIT_BC_DELAY,
          **clock_box_params([0, @initial_read_sec, 0, 0]),
        })
    end

    it "当事者側(自分は即座に起動してBC)" do
      a_block { case1("alice") }
      b_block { case1("bob")   }
      a_block { clock_start    }
      a_block do
        sleep(@initial_read_sec)
        Capybara.using_wait_time(@CC_TIME_LIMIT_BC_DELAY * 2) do
          assert_text("当事者は自分で起動してBC")
          assert_time_limit_modal_exist
          assert_text("BC受信時にはすでにモーダル起動済み")
        end
      end
      b_block { assert_time_limit_modal_exist }
    end

    it "他者側(予約するがBCの方が速いのでキャンセルされる)" do
      @CC_TIME_LIMIT_BC_DELAY   = 2
      @CC_AUTO_TIME_LIMIT_DELAY = 4
      a_block { case1("alice") }
      b_block { case1("bob")   }
      a_block { clock_start    }
      b_block do
        sleep(@initial_read_sec)
        Capybara.using_wait_time(@CC_TIME_LIMIT_BC_DELAY * 2) do
          assert_text("BC受信によってモーダル起動開始")
          assert_text("時間切れ予約キャンセル")
          assert_time_limit_modal_exist
        end
      end
      a_block { assert_time_limit_modal_exist }
    end

    it "他者側(予約待ち0なので他者側で即発動)" do
      @CC_TIME_LIMIT_BC_DELAY   = 5
      @CC_AUTO_TIME_LIMIT_DELAY = 0
      a_block { case1("alice") }
      b_block { case1("bob")   }
      a_block { clock_start    }
      b_block do
        sleep(@initial_read_sec)
        Capybara.using_wait_time(@CC_TIME_LIMIT_BC_DELAY * 2) do
          assert_text("BC受信時にはすでにモーダル起動済み")
          assert_time_limit_modal_exist
        end
      end
      a_block { assert_time_limit_modal_exist }
    end
  end

  describe "ハンドルネームバリデーション" do
    def case1(name, message)
      find(".HandleNameModal input").set(name)         # 不正な名前を入力する
      find(".save_handle").click                       # 保存
      assert_text(message)                             # エラー出る
    end

    it "works" do
      a_block do
        visit_app
        hamburger_click
        menu_item_click("ハンドルネーム変更")
        case1("", "ハンドルネームを入力してください")
        case1("名無し", "ハンドルネームを入力してください")
        case1(".", "ハンドルネームを入力してください")
      end
    end
  end

  describe "URLから来ても不正なハンドルネームは通さない" do
    it "works" do
      a_block do
        visit_app(room_code: :my_room, force_user_name: "nanashi", ordered_member_names: "nanashi")
        assert_text("部屋に入る")                         # ハンドルネームが不正なのでダイアログが出ている
      end
    end
  end

  describe "KI2棋譜コピー" do
    it "works" do
      visit_app
      hamburger_click
      menu_item_sub_menu_click("棋譜コピー")
      menu_item_click("KI2")
      assert_text("コピーしました")
    end
  end

  describe "指し手の消費秒数を表示" do
    it "works" do
      a_block do
        visit_app(room_code: :my_room, force_user_name: "alice")
        clock_start_force
        sleep(2)                                   # 2秒待つ
        piece_move_o("77", "76", "☗7六歩")         # 初手を指す
        action_log_row_of(0).text.match?(/[23]秒/) # 右側に "alice 1 ☗7六歩 2秒" と表示している
        # assert_text は overflow-x: hidden で隠れている場合があるためランダムに失敗する
      end
    end
  end

  describe "編集モードで配置を変更しても駒箱が消えない" do
    it "works" do
      visit_app
      hamburger_click
      menu_item_click("局面編集")
      find(".EditToolBlock .dropdown:nth-of-type(2)").click # 左から2つ目の dropdown をクリック
      menu_item_sub_menu_click("駒箱に駒を一式生成")
      piece_move("77", "76")                                # 駒移動で edit_mode の sfen の emit が飛ぶ
      assert_selector(".PieceBox .PieceTap")                # でも駒箱に駒は消えていない
    end
  end

  describe "操作履歴" do
    it "操作履歴から過去の局面に戻る" do
      def config
        {
          :room_code            => :my_room,
          :ordered_member_names => "alice,bob",
          :quick_sync_key       => "is_quick_sync_off", # 手動同期にしておく
        }
      end

      a_block do
        visit_app(config.merge(force_user_name: "alice"))
      end
      b_block do
        visit_app(config.merge(force_user_name: "bob"))
      end
      a_block do
        piece_move_o("77", "76", "☗7六歩")
        assert_turn(1)
      end
      b_block do
        piece_move_o("33", "34", "☖3四歩")
        assert_turn(2)
      end
      a_block do
        action_log_row_of(1).click   # 初手(76歩)の行をクリックしてモーダル起動
        apply_button # N手目まで戻る実行
        assert_turn(1)        # 1手目に戻った
      end
      b_block do
        assert_turn(2)        # 戻るのはalice側だけなのでbob側は2手目のまま
      end
    end

    it "操作履歴モーダル内の補助機能" do
      a_block do
        visit_app(room_code: :my_room, force_user_name: "alice", ordered_member_names: "alice")
        piece_move_o("77", "76", "☗7六歩")               # 初手を指す
        assert_turn(1)
        action_log_row_of(0).click                      # 初手(76歩)の行をクリックしてモーダル起動

        find(".KentoButton").click                      # 「KENTO」
        assert_text("KENTO起動")

        find(".PiyoShogiButton").click                  # 「ぴよ将棋」
        assert_text("ぴよ将棋起動")

        find(".KifCopyButton").click                    # 「コピー」
        assert_text("棋譜コピー")

        find(".room_code_except_url_copy_handle").click # 「リンク」
        assert_text("棋譜リンクコピー")
      end
    end

    it "操作履歴モーダル内で局面を調整する" do
      a_block do
        visit_app
        piece_move_o("77", "76", "☗7六歩")
        piece_move_o("33", "34", "☖3四歩")
        assert_turn(2)                                    # 現在2手目
        action_log_row_of(0).click                        # 一番上の2手目を記憶した行をクリックしてモーダル起動
        Capybara.within(".ActionLogJumpPreviewModal") do
          assert_text("局面 #2")                          # 当然2手目になっている
          find(".button.previous").click                  # 「<」で1手目に進めると
          assert_text("局面 #1")                          # 1手目になっている
        end
        find(".apply_button").click                       # 「N手目まで戻る」
        assert_turn(1)                                    # 1手目に変更されている
      end
    end
  end

  describe "ツイート" do
    it "ツイートモーダル" do
      a_block do
        visit_app
        find(".tweet_modal_handle").click   # モーダル起動
        assert_text("この局面をツイート")
        find(".TweetModal .dropdown").click # テーマ選択
        assert_text("紙面風")
      end
    end

    it "ツイート画像の視点設定" do
      a_block do
        visit_app
        hamburger_click
        menu_item_click("ツイート画像の視点設定")                 # 開く
        assert_selector(".AbstractViewpointKeySelectModal")       # モーダルが開いている
        find(".AbstractViewpointKeySelectModal .white").click     # 「常に☖」を選択
        find(".submit_handle").click                              # 「保存」
        assert_no_selector(".AbstractViewpointKeySelectModal")    # モーダルが閉じている
        assert { current_query["abstract_viewpoint"] == "white" } # URLが変更になっている
      end
    end
  end

  describe "画像ダウンロード" do
    it "works" do
      a_block do
        visit_app
        hamburger_click
        menu_item_click("画像ダウンロード")         # 開く
        assert_selector(".ImageDlModal")            # モーダルが開いている

        find(".image_size_key_dropdown").click      # サイズ変更ドロップダウンを開く
        find(".is_image_size_1600x1200").click      # サイズ確定

        find(".ShareBoardColorThemeDropdown").click # 配色変更ドロップダウンを開く
        find(".is_color_theme_piyo").click          # 配色確定

        if false
          find(".download_handle").click            # ダウンロード実行
        end
        find(".close_handle").click                 # 閉じる
      end
    end
  end

  describe "手番でないのに動かそうとしたときの反応" do
    def case1
      a_block do
        visit_app(room_code: :my_room, force_user_name: "alice", ordered_member_names: "alice,bob")
      end
      b_block do
        visit_app(room_code: :my_room, force_user_name: "bob", ordered_member_names: "alice,bob")
      end
      c_block do
        visit_app(room_code: :my_room, force_user_name: "carol", ordered_member_names: "alice,bob")
      end
    end
    it "時計OFF順番設定ONでは検討をしていると思われる" do
      case1
      b_block do
        place_click("77")
        assert_text("(今はaliceさんの手番です。検討する場合は順番設定を解除してください)")
      end
    end
    it "時計OFF順番設定ONでは検討をしていると思われるときに観戦者が操作しようとした" do
      case1
      c_block do
        place_click("77")
        assert_text("(今はaliceさんの手番です。あなたは観戦者なので操作できません。検討する場合は順番設定を解除してください)")
      end
    end
    it "時計ON順番設定ONは対局中と思われる" do
      case1
      b_block do
        clock_start
        place_click("77")
        assert_text("(今はaliceさんの手番です)")
      end
    end
    it "順番設定で誰も参加していない" do
      a_block do
        visit_app(room_code: :my_room, force_user_name: "alice", ordered_member_names: "")
        place_click("77")
        assert_text("(順番設定で対局者の指定がないので誰も操作できません)")
      end
    end
  end

  describe "後から部屋に入ったときの同期" do
    describe "盤面" do
      it "最大2手まである棋譜の1手目を指している部屋に入ったとき1手目になる" do
        a_block do
          visit_app(room_code: :my_room, force_user_name: "alice", ordered_member_names: "alice,bob", body: "76歩34歩")
          sp_controller_click(:previous)      # 最長2手まである棋譜の1手目に戻す
          assert_turn(1)                      # 0手目に戻っている
          sleep(2)                            # 1秒後に転送するためそれが切れるまで待つ
        end
        b_block do
          visit_app(room_code: :my_room, force_user_name: "bob")
          assert_turn(1)                      # あとから来た bob は2手目ではなく1手目の局面になっている
        end
      end
    end
    describe "順番設定" do
      it "works" do
        a_block do
          visit_app(room_code: :my_room, force_user_name: "alice", ordered_member_names: "alice,bob")
          assert_text("order_enable_p:true")
        end
        b_block do
          visit_app(room_code: :my_room, force_user_name: "bob")
          assert_text("order_enable_p:true")
        end
      end
    end
    describe "時計" do
      it "works" do
        a_block do
          visit_app(room_code: :my_room, force_user_name: "alice")
          clock_open
          assert_text("clock_box:true")
        end
        b_block do
          visit_app(room_code: :my_room, force_user_name: "bob")
          assert_text("clock_box:true")
        end
      end
    end
    describe "タイトル" do
      it "works" do
        a_block do
          visit_app(room_code: :my_room, force_user_name: "alice", title: "(new_title)")
        end
        b_block do
          visit_app(room_code: :my_room, force_user_name: "bob")
          assert_text("(new_title)")
        end
      end
    end
  end

  describe "順番設定の下のわかりにくいオプションの説明" do
    def case1(label, message)
      find(".OrderSettingModal span", text: label, exact_text: true).click
      assert_text(message)
    end

    it "works" do
      visit_app(room_code: :my_room, force_user_name: "alice")
      hamburger_click
      os_modal_handle            # 「順番設定」モーダルを開く
      find(".main_switch").click # 右上の有効スイッチをクリック
      case1("反則制限", "二歩")
      case1("アバター", "玉として表示します")
      case1("シャウト", "駒が無駄に叫びます")
      case1("N手毎交代", "1人10手毎交代のようなルール")
      case1("手番制限", "手番の人だけが駒を動かせる")
    end
  end

  describe "Aが対局時計操作中にCが入室したときBはCだけに時計情報を送るのでAの対局時計がBの内容で更新されない" do
    it "works" do
      a_block do
        visit_app(room_code: :my_room, force_user_name: "alice")
      end
      b_block do
        visit_app(room_code: :my_room, force_user_name: "bob")
      end
      c_block do
        visit_app(room_code: :my_room, force_user_name: "carol")
        text_click "[入室時の情報要求]"
      end
      a_block do
        assert_no_text "alice は bob の時計情報を受信して反映した"
      end
    end
  end

  it "棋譜の読み込み" do
    visit_app(room_code: :my_room, force_user_name: "alice")
    hamburger_click
    menu_item_click("棋譜の読み込み")
    find(".AnySourceReadModal textarea").set("68S", clear: :backspace)
    find(".AnySourceReadModal .submit_handle").click

    action_assert(0, "alice", "局面転送 #1")
    action_assert(1, "alice", "棋譜読込後(本筋)")
    assert_text "棋譜を読み込んで共有しました"
  end

  describe "駒を持ち上げた状態で順番設定が変更になり手番が切り替わると駒を元に戻す" do
    it "works" do
      a_block do
        visit_app(room_code: :my_room, force_user_name: "alice", ordered_member_names: "alice,bob")
      end
      b_block do
        visit_app(room_code: :my_room, force_user_name: "bob", ordered_member_names: "alice,bob")
      end
      a_block do
        place_click("77")           # alice は77の駒を持つ
        lifted_from("77")           # 77の駒を持っていることを保証する
      end
      b_block do
        hamburger_click
        os_modal_handle # 「順番設定」モーダルを開く(すでに有効になっている)
        find(".swap_handle").click  # 先後入替
        apply_button                # 適用
        modal_close_handle          # 閉じる
      end
      a_block do
        no_lifted_from("77")        # alice は77の駒を持っていたはずだが手番が変わったため駒を元に戻した
      end
    end
  end

  describe "順番設定後はハンドルネームを変更させない" do
    it "works" do
      a_block do
        visit_app(room_code: :my_room, force_user_name: "alice", ordered_member_names: "alice")
        hamburger_click
        menu_item_click("ハンドルネーム変更")
        assert_text "いったん順番設定を無効にしてください"
      end
    end
  end

  describe "入室したとき他に誰もいなかったら部屋のリンクのクリックを促す" do
    it "works" do
      a_block do
        room_setup("my_room", "alice")
        assert_member_exist("alice")
        assert_text "部屋のリンクを仲間に伝えよう"
      end
      b_block do
        room_setup("my_room", "bob")
        assert_member_exist("bob")
        assert_no_text "部屋のリンクを仲間に伝えよう"
      end
    end
  end

  describe "順番設定後に時計設置を促す" do
    it "works" do
      a_block do
        room_setup("my_room", "alice")
        hamburger_click
        os_modal_handle # 「順番設定」モーダルを開く
        find(".main_switch").click  # 有効スイッチをクリック (最初なので同時に適用を押したの同じで内容も送信)
        apply_button                # 適用クリック
        assert_text "次は時計を設置してください"
      end
    end
  end

  describe "対局時計個別設定" do
    it "片方を変更したとき片方は連動しない" do
      a_block do
        room_setup("my_room", "alice")
        clock_open
        clock_box_set(1, 2, 3, 4)                     # aliceが時計を設定する
        find(".cc_unique_mode_set_handle").click      # 個別設定を押す
        cc_in(2) do
          clock_box_values_eq [1, 2, 3, 4]            # ▲側が△にコピーされている
          clock_box_set(5, 6, 7, 8)                   # △側を更新する
        end
        cc_in(1) do
          clock_box_values_eq [1, 2, 3, 4]            # ▲側は変更されていない (内容は同じだが別のメモリを指している)
        end
        # find(".play_button").click                    # 開始
      end
      b_block do
        room_setup("my_room", "bob")
        assert_text "cc_params:[[1,2,3,4],[5,6,7,8]]" # 個別設定がbobにも伝わっている
      end
    end
  end

  describe "対局時計にプリセット適用" do
    it "works" do
      visit_app
      clock_open
      Capybara.within(".preset_dropdown") do
        find(".preset_dropdown_button").click       # プリセットを開く
        find(".dropdown-item:nth-of-type(1)").click # 一番上の「ウォーズ10分」を適用
      end
      clock_box_values_eq [10, 0, 0, 0]             # 設定されている
    end
  end

  describe "棋譜に対局者名を含める" do
    it "部屋を立てていないときはURLから取得する" do
      visit_app(title: "(title)", black: "(alice)")
      hamburger_click
      menu_item_sub_menu_click("棋譜表示")
      menu_item_click("KIF")
      switch_to_window_last
      assert_text "棋戦：(title)"
      assert_text "先手：(alice)"
    end

    it "部屋を立てた後はメンバーリストから取得する" do
      a_block do
        visit_app(room_code: :my_room, force_user_name: "alice", ordered_member_names: "alice,bob", title: "(title)")
      end
      b_block do
        visit_app(room_code: :my_room, force_user_name: "bob")
      end
      c_block do
        visit_app(room_code: :my_room, force_user_name: "carol")
      end
      a_block do
        hamburger_click
        menu_item_sub_menu_click("棋譜表示")
        menu_item_click("KIF")
        switch_to_window_last
        assert_text "棋戦：(title)"
        assert_text "先手：alice"
        assert_text "後手：bob"
        assert_text "観戦：carol"
      end
    end

    it "操作履歴にも含んでいる" do
      a_block do
        visit_app(black: "alice")
        piece_move_o("77", "76", "☗7六歩")
        action_log_row_of(0).click
        Capybara.within(".ActionLogJumpPreviewModal") do
          assert_text('"black": "alice"') # デバッグ情報の表示を見ている
        end
      end
    end

    it "メンバーからコピーできる" do
      visit_app(room_code: :my_room, force_user_name: "alice", ordered_member_names: "alice,bob", title: "(title)")
      find(".player_names_copy_handle").click
      assert_text "コピーしました"
    end
  end
end
