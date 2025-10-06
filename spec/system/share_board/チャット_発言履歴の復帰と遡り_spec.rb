require "#{__dir__}/shared_methods"

RSpec.describe "チャット_発言履歴の復帰と遡り", type: :system, share_board_spec: true do
  let(:content1) { SecureRandom.hex }

  it "完全に抜けた状態から再度入室すると発言履歴がある" do
    chat_message_setup(1)                                                 # 1件用意する
    visit_room(room_key: :test_room, user_name: "alice", mh_per_page: 1)   # 入室する
    assert_var("ml_count", 0)                                 # 件数は 0
    chat_modal_open { assert_message_received_o("(content:0)") }          # チャットを開いたタイミングで読み込む
    assert_var("ml_count", 1)                                 # 件数は 1
  end

  it "初回のスクロール位置はいちばん下になっている" do
    chat_message_setup(100)                                               # 100件用意する
    visit_room(room_key: :test_room, user_name: "alice", mh_per_page: 50)  # 1回で50件読む
    assert_var("ml_count", 0)                                 # 件数は 0
    chat_modal_open do
      assert_message_received_o("(content:99)")                           # 50..99 は有り
      assert_message_received_x("(content:49)")                           #  0..49 は無し
      assert { chat_scroll_ratio == 0.9 }                                 # 一番下までスクロールしている
      assert_mh_page_index_in_modal(1)                                    # APIへのアクセスは1回のみ
      assert_ml_count_in_modal(50)                                        # いまは50件ある
    end
  end

  it "よそ見から復帰したとき(タブを切り替えて戻ったとき)に最新にするためリロードする" do
    chat_message_setup(1)                                                 # 1件用意する
    a_block do
      visit_room(room_key: :test_room, user_name: "alice", mh_per_page: 1) # 入室する
      chat_modal_open                                                     # チャットを開いたら
      assert_ml_count_in_modal(1)                                         # 1件読み込まれる
      find(".ChatModal .mh_reset_all").click                              # デバッグ用の「初期化」をクリックすると
      assert_ml_count_in_modal(0)                                         # 0件になるが、
    end
    if false
      b_block { }                                                          # タブを切り替えて戻る (headless だと visibilitychange が効かないため)
    else
      a_block { find(".ChatModal .mh_reload").click }                     # デバッグ用の「よそ見から復帰」をクリックすると
    end
    a_block do
      assert_ml_count_in_modal(1)                                         # リロードされ1件読み込まれている
    end
  end

  it "遡って昔の発言を参照する" do
    chat_message_setup(100)                                               # 100件用意する
    visit_room(room_key: :test_room, user_name: "alice", mh_per_page: 40)  # 1回で40件読む (つまり3回のアクセスが必要)
    chat_modal_open do                                                    # チャットを開いたタイミングで40件読む
      assert_mh_page_index_in_modal(1)                                    # APIアクセス1回目
      chat_scroll_to_top_with_wait                                        # 最上位までスクロールしたので残りのうち40件を読んで80件になる
      assert_mh_page_index_in_modal(2)                                    # APIアクセス2回目
      chat_scroll_to_top_with_wait                                        # 再度最上位までスクロールしたので残りのうち20件を読んで100件になる
      assert_mh_page_index_in_modal(3)                                    # APIアクセス3回目
      assert_message_received_o("(content:0)")                            # するといちばん古い発言が見えている
    end
  end

  it "入室と退室のタイミングで履歴を消す" do
    chat_message_setup(2)                                                 # 2件用意する

    visit_app(mh_per_page: 10)                                            # 来る
    assert_var("ml_count", 0)                                 # 発言履歴は空
    chat_modal_open { chat_message_send(content1) }                       # チャットを開いて(DBに入らない)発言をする
    assert_var("ml_count", 1)                                 # 発言履歴数は 1 になっている

    room_menu_open_and_input("test_room", "alice")                        # 入室すると
    assert_var("ml_count", 0)                                 # 発言履歴は初期化されて 0 になっている

    chat_modal_open { assert_message_received_o("(content:0)") }          # そこでチャットを開くとそのタイミングで読み込まれる
    assert_var("ml_count", 2)                                 # 念のため個数を確認する (2件用意していて1ページあたり10件のため2件ある)

    room_leave                                                            # 退室する
    assert_var("ml_count", 0)                                 # このタイミングでも履歴消去しているので 0 になっている
  end
end
