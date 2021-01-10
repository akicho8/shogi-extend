require "rails_helper"

RSpec.describe "共有将棋盤", type: :system do
  it "最初" do
    visit "http://localhost:4000/share-board"
    expect(page).to have_content "共有将棋盤"
    doc_image
  end

  it "駒落ちで開始したとき△側が下に来ている" do
    visit "http://localhost:4000/share-board?body=position+sfen+4k4%2F9%2F9%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+w+-+1&turn=0&title=%E6%8C%87%E3%81%97%E7%B6%99%E3%81%8E%E3%83%AA%E3%83%AC%E3%83%BC%E5%B0%86%E6%A3%8B"
    assert_selector(".CustomShogiPlayer .is_viewpoint_white")
    doc_image
  end

  it "合言葉を含むURLから来てハンドルネーム入力して接続して駒を動かす" do
    visit "http://localhost:4000/share-board?room_code=foo" # 合言葉を含むURLから来た
    assert_selector(".RealtimeShareModal")                  # 「合言葉の設定と共有」のモーダル表示
    expect(page).to have_content "合言葉の設定と共有"       # 〃
    first(".new_user_name input").set("alice")              # ハンドルネーム入力
    first(".modal-card-foot .button.is-primary").click      # 共有
    expect(page).to have_content "alice"                    # 入力したハンドルネームの人が参加している
    first(".place_7_7").click                               # 77の歩を持って
    first(".place_7_6").click                               # 77に移動
    expect(page).to have_content "☗7六歩"                  # 符号が表示されている
    doc_image
  end

  # BROWSER_DEBUG=1 rspec ~/src/shogi-extend/spec/system/share_board_spec.rb -e 'ログインしていない状態から合言葉とニックネームを入力'
  # Capybara.default_max_wait_time = 1
  it "ログインしていない状態から合言葉とニックネームを入力" do
    share_board_setup("my_room", "alice")

    visit "http://localhost:4000/share-board"                          # 再来
    find(".sidebar_toggle_navbar_item").click                          # サイドメニュー起動
    first(:xpath, "//*[contains(text(), '合言葉の設定と共有')]").click # 「合言葉の設定と共有」クリック
    first(".new_room_code input").set("my_room")                       # 合言葉
    value = first(".new_user_name input").value                        # 前で入力した内容が
    assert { value == "alice" }                                        # 復元されている
    first(".modal-card-foot .button.is-primary").click                 # 共有

    find(".sidebar_toggle_navbar_item").click                          # サイドメニュー起動
    first(:xpath, "//*[contains(text(), 'URLを開いたときの局面に戻す')]").click # 「合言葉の設定と共有」クリック
    first(".place_5_9").click                                          # 59の歩を持って
    first(".place_5_8").click                                          # 58に移動
    expect(page).to have_content "☗5八玉"                             # 符号が表示されている

    # bob がログインする
    bobs_window = Capybara.open_new_window
    Capybara.within_window(bobs_window) do
      share_board_setup("my_room", "bob")
      expect(page).to have_content "alice"                             # aliceがいる
      doc_image("bobはaliceの盤面を貰った")
    end

    expect(page).to have_content "bob"                                 # alice側にはbobがいる

    # bob が指す
    Capybara.within_window(bobs_window) do
      first(".place_3_3").click                                        # 33の歩を持って
      first(".place_3_4").click                                        # 34に移動
      expect(page).to have_content "☖3四歩"                           # 符号が表示されている
      # debugger
    end

    expect(page).to have_content "☖3四歩"                             # aliceの画面にも符号が表示されている
    doc_image("aliceとbobは画面を共有している")
  end

  def share_board_setup(room_code, user_name)
    visit "http://localhost:4000/share-board"
    find(".sidebar_toggle_navbar_item").click                          # サイドメニュー起動
    first(:xpath, "//*[contains(text(), '合言葉の設定と共有')]").click # 「合言葉の設定と共有」クリック
    first(".new_room_code input").set(room_code)                       # 合言葉
    first(".new_user_name input").set(user_name)                       # ハンドルネーム
    first(".modal-card-foot .button.is-primary").click                 # 共有
    expect(page).to have_content user_name                             # 入力したハンドルネームの人が参加している
  end
end
