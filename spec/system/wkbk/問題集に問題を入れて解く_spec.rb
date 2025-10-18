require "rails_helper"

RSpec.describe type: :system do
  include ShogiPlayerMethods

  it "works" do
    eval_code %(Wkbk.setup(force: true))                                 # ユニークバリデーションにひっかかるため初期化しておく
    login                                                                # 問題を作るにはログインが必須になる

    visit_to "/rack/books/new"                                             # 問題集の新規で
    find(".book_title input").set("TEST_BOOK1", clear: :backspace)       # タイトルを入力して
    find("a", text: "保存", exact_text: true).click                      # 保存する

    visit_to "/rack/articles/new"                                          # 問題の新規で
    find("a", text: "正解", exact_text: true).click                      # 「正解」タブに移動して
    piece_move("77", "76")                                               # 角道を開ける初手「76歩」を
    piece_move("33", "34")                                               # 角道を開ける初手「76歩」を
    piece_move("27", "26")                                               # 角道を開ける初手「76歩」を
    find(:button, "3手目までの手順を正解とする", exact_text: true).click # 正解として登録する
    find("a", text: "情報", exact_text: true).click                      # 続いて「情報」タブに移動して
    find(".article_title input").set("TEST_ARTICLE1", clear: :backspace) # 問題のタイトルを決めて
    find(:label, "TEST_BOOK1").click                                     # さっき作った問題集に入れて
    find("a", text: "保存", exact_text: true).click                      # 保存する

    visit_to "/rack"                                                       # トップページに移動して
    find(".title", text: "TEST_BOOK1", exact_text: true).click           # さっき作った問題集を選択して
    find(".play_start_handle").click                                     # START ボタンで開始する
    sidebar_open                                                      # メニューを開く
    Capybara.within(".soldier_flop_key") { Capybara.find(:label, text: "する", exact_text: true).click } # 「盤上の駒を左右反転」する
    sidebar_close                                                      # メニューを閉じる
    within(first(".CustomShogiPlayer")) { piece_move("37", "36") }             # 1手目 76歩 (左右反転しているため36歩) を入力すると相手が次を指し、
    within(first(".CustomShogiPlayer")) { piece_move("87", "86") }             # 3手目 26歩 (左右反転しているため86歩) を入力すると正解して
    assert_selector(".play_start_handle")                                # 問題集の画面に戻る
  end
end
