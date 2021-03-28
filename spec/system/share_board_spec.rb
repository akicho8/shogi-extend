require "rails_helper"

RSpec.describe "共有将棋盤", type: :system do
  it "最初に来たときのタイトルが正しい" do
    visit "/share-board"
    expect(page).to have_content "共有将棋盤"
    doc_image
  end

  it "駒落ちで開始したとき△側が下に来ている" do
    visit "/share-board?body=position+sfen+4k4%2F9%2F9%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+w+-+1&turn=0&title=%E6%8C%87%E3%81%97%E7%B6%99%E3%81%8E%E3%83%AA%E3%83%AC%E3%83%BC%E5%B0%86%E6%A3%8B"
    assert_selector(".CustomShogiPlayer .is_viewpoint_white")
    doc_image
  end

  it "合言葉を含むURLから来てハンドルネーム入力して接続して駒を動かす" do
    visit "/share-board?room_code=foo"                # 合言葉を含むURLから来る
    assert_selector(".RealtimeShareModal")            # 「合言葉の設定と共有」のモーダルが自動的に表示されている
    expect(page).to have_content "合言葉の設定と共有" # 「合言葉の設定と共有」のモーダルのタイトルも正しい
    first(".new_user_name input").set("alice")        # ハンドルネームを入力する
    first(".share_button").click                      # 共有ボタンをクリックする
    expect(page).to have_content "alice"              # 入力したハンドルネームの人がメンバーリストに表示されている
    assert_move("77", "76", "☗7六歩")
    doc_image
  end

  # BROWSER_DEBUG=1 rspec ~/src/shogi-extend/spec/system/share_board_spec.rb -e 'ログインしていない状態から合言葉とニックネームを入力'
  # Capybara.default_max_wait_time = 1
  it "ログインしていない状態から合言葉とニックネームを入力" do
    room_setup("my_room", "alice")

    visit "/share-board"                                      # 再来
    find(".sidebar_toggle_navbar_item").click                 # サイドメニューを起動する
    click_text_match("合言葉の設定と共有")                    # 「合言葉の設定と共有」を自分でクリックする
    first(".new_room_code input").set("my_room")              # 合言葉を入力する
    assert { first(".new_user_name input").value == "alice" } # 以前入力したニックネームが復元されている
    first(".share_button").click                              # 共有ボタンをクリックする
    assert_move("59", "58", "☗5八玉")
                                                              # bob が別の画面でログインする
    bowindow_b = Capybara.open_new_window
    Capybara.within_window(bowindow_b) do
      room_setup("my_room", "bob")                     # alice と同じ部屋の合言葉を設定する
      expect(page).to have_content "alice"                    # すでにaliceがいるのがわかる
      doc_image("bobはaliceの盤面を貰った")
    end

    expect(page).to have_content "bob"                        # alice側の画面にはbobが表示されている

    Capybara.within_window(bowindow_b) do
      assert_move("33", "34", "☖3四歩")
    end

    expect(page).to have_content "☖3四歩"                     # aliceの画面にもbobの指し手の符号が表示されている
    doc_image("aliceとbobは画面を共有している")
  end

  # cd /Users/ikeda/src/shogi-extend/ && BROWSER_DEBUG=1 rspec /Users/ikeda/src/shogi-extend/spec/system/share_board_spec.rb -e 'タイトル共有'
  describe "タイトル共有" do
    it "works" do
      room_setup("my_room", "alice")    # alceが部屋を作る
      bowindow_b = Capybara.open_new_window
      Capybara.within_window(bowindow_b) do
        room_setup("my_room", "bob")    # bobもaliceと同じ合言葉で部屋を作る
        first(".title_edit_navbar_item").click # タイトル変更モーダルを開く
        within(".modal-card") do
          first("input").set("(new_title)")    # 別のタイトルを入力
          find(".button.is-primary").click     # 更新ボタンを押す
        end
      end
      assert_text("(new_title)")               # alice側のタイトルが変更されている
    end
  end

  # cd /Users/ikeda/src/shogi-extend/ && BROWSER_DEBUG=1 rspec /Users/ikeda/src/shogi-extend/spec/system/share_board_spec.rb -e '対局時計'
  describe "対局時計" do
    INITIAL_MAIN_MIN = 5

    before do
      @window_a = Capybara.open_new_window
      @window_b = Capybara.open_new_window
    end

    after do
      [@window_a, @window_b].each(&:close)
    end

    def a_block(&block)
      Capybara.within_window(@window_a, &block)
    end

    def b_block(&block)
      Capybara.within_window(@window_b, &block)
    end

    it "works" do
      a_block do
        room_setup("my_room", "alice")      # aliceが部屋を作る
      end
      b_block do
        room_setup("my_room", "bob")        # bobも同じ部屋に入る
      end
      a_block do
        find(".sidebar_toggle_navbar_item").click  # サイドメニューを開く
        click_text_match("対局時計の設置")         # 「対局時計の設置」モーダルを開く
        assert_clock_off                           # 時計はまだ設置されていない
        find(".chess_clock_switch_handle").click   # 設置する
        assert_clock_on                            # 時計が設置された
      end
      b_block do
        assert_clock_on                            # 同期してbob側にも設置されている
      end
      a_block do
        chess_clock_set(0, INITIAL_MAIN_MIN, 0, 0) # aliceが時計を設定する
        find(".play_button").click                 # 開始
        find(".close_button").click                # 閉じる
        assert_move("27", "26", "☗2六歩")          # 初手を指す
        assert_clock_active_white                  # 時計を同時に押したので後手がアクティブになる
      end
      b_block do
        assert_clock_active_white                  # bob側も後手がアクティブになっている
        assert_white_read_sec(INITIAL_MAIN_MIN)    # 秒読みが満タン
        sleep(INITIAL_MAIN_MIN)                    # 秒読みぶん待つ
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

  def room_setup(room_code, user_name)
    visit "/share-board"
    find(".sidebar_toggle_navbar_item").click    # サイドメニュー起動する
    click_text_match("合言葉の設定と共有")       # 「合言葉の設定と共有」を自分でクリックする
    first(".new_room_code input").set(room_code) # 合言葉を入力する
    first(".new_user_name input").set(user_name) # ハンドルネームを入力する
    first(".share_button").click                 # 共有ボタンをクリックする
    expect(page).to have_content user_name       # 入力したハンドルネームの人が参加している
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
    [from, to].each do |e|
      find([".place", e.chars].join("_")).click
    end
    assert_text(human)
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
end
