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
    first(".RealtimeShareModal input").set("(漢字)")        # ハンドルネーム入力
    first(".modal-card-foot .button.is-primary").click      # 確定
    expect(page).to have_content "(漢字)"                   # 入力したハンドルネームの人が参加している
    first(".place_7_7").click                               # 77の歩を持って
    first(".place_7_6").click                               # 77に移動
    expect(page).to have_content "☗7六歩(77)"              # 符号が表示されている
    doc_image
  end
end
