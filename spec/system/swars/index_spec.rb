require "rails_helper"

RSpec.describe "将棋ウォーズ棋譜検索", type: :system, swars_spec: true do
  include SwarsSystemSupport

  describe "始めて来た" do
    it "引数なしで来たときの画面" do
      visit2 "/swars/search"
      assert_text "将棋ウォーズ棋譜検索"
      assert_query ""
      assert_list_blank
    end
  end

  describe "クエリ検索" do
    it "検索フォームに入力して検索する" do
      visit2 "/swars/search"
      fill_in "query", with: "Yamada_Taro"
      assert_query "Yamada_Taro"
      find(".search_click_handle").click
      assert_list_present
    end

    it "謎の空白が混入するBiDi問題" do
      visit2 "/swars/search"
      fill_in "query", with: "\u{202A}Yamada_Taro\u{202C}"
      find(".search_click_handle").click
      assert_list_present
    end

    describe "検索クエリ内各パラメータ" do
      it "ウォーズIDだけを指定する" do
        visit2 "/swars/search", query: "Yamada_Taro"
        assert_query "Yamada_Taro"
        assert_list_present
      end

      it "対戦相手で絞る" do
        visit2 "/swars/search", query: "Yamada_Taro vs:devuser2"
        assert_var_eq(:records_length, 1)
      end

      it "囲い名で絞る" do
        visit2 "/swars/search", query: "Yamada_Taro tag:舟囲い"
        assert_var_eq(:records_length, 3)

        visit2 "/swars/search", query: "Yamada_Taro tag:高美濃囲い"
        assert_var_eq(:records_length, 0)
      end
    end
  end

  describe "一覧要素の一番上の対局の各操作ボタンをタップする" do
    before do
      visit2 "/swars/search", query: "Yamada_Taro"
    end

    it "ぴよ将棋" do
      first(".PiyoShogiButton").click
      switch_to_window(windows.last) # 別にタブで開いているのでタブを切り替える
      assert_text("ぴよ将棋w")
      assert_text("後手:Yamada_Taro 四段")
      assert_text("先手:devuser3 三段")
      assert { current_url == "https://www.studiok-i.net/ps/?num=34&sente_name=devuser3%20%E4%B8%89%E6%AE%B5&gote_name=Yamada_Taro%20%E5%9B%9B%E6%AE%B5&game_name=%E5%B0%86%E6%A3%8B%E3%82%A6%E3%82%A9%E3%83%BC%E3%82%BA(10%E5%88%86)&sfen=position%20sfen%20lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL%20b%20-%201%20moves%205g5f%208c8d%207g7f%208d8e%208h7g%206a5b%202h5h%207a6b%207i6h%205a4b%206h5g%204b3b%205i4h%201c1d%201g1f%206c6d%205f5e%206b6c%205g5f%203a4b%204h3h%204c4d%203h2h%204b4c%203i3h%207c7d%209g9f%209c9d%209i9g%203c3d%204g4f%202b3c%205h9h%208e8f%208g8f%208b8d%206i5h%203b2b%209f9e%209d9e%209g9e%20P*9d%209e9d%209a9d%20P*9e%207d7e%207f7e%203c2d%205h4g%204a3b%209e9d%205c5d%20L*8e%205d5e%205f5e%20P*7f%207g9i%208d8e%208f8e%202d3c%204f4e%20L*8f%205e4d%204c4d%209i4d%208f8i%2B%20S*4a%20S*4c%204a3b%2B%204c3b%209d9c%2B%203c4d%204e4d%20L*4e%204d4c%2B%204e4g%2B%204c3b%202b3b%203h4g%207f7g%2B%209c8c%20B*6e%209h9b%2B%206e4g%2B%20L*4h%20P*4f%204h4g%204f4g%2B%20P*4h%20S*5h%204i3i%20L*3h%203i3h%204g3h%202h3h%20S*1g%20B*5d%20G*4c%205d4c%2B%203b4c%20L*4f%20N*4d%202i1g%20B*5g%20S*5e%20G*5d%20R*4a%204c3c%205e4d" }
    end

    it "KENTO" do
      first(".KentoButton").click
      switch_to_window(windows.last) # 別にタブで開いているのでタブを切り替える
      assert_text("KENTO にログイン")
      assert { current_url == "https://www.kento-shogi.com/?moves=5g5f.8c8d.7g7f.8d8e.8h7g.6a5b.2h5h.7a6b.7i6h.5a4b.6h5g.4b3b.5i4h.1c1d.1g1f.6c6d.5f5e.6b6c.5g5f.3a4b.4h3h.4c4d.3h2h.4b4c.3i3h.7c7d.9g9f.9c9d.9i9g.3c3d.4g4f.2b3c.5h9h.8e8f.8g8f.8b8d.6i5h.3b2b.9f9e.9d9e.9g9e.P%2A9d.9e9d.9a9d.P%2A9e.7d7e.7f7e.3c2d.5h4g.4a3b.9e9d.5c5d.L%2A8e.5d5e.5f5e.P%2A7f.7g9i.8d8e.8f8e.2d3c.4f4e.L%2A8f.5e4d.4c4d.9i4d.8f8i%2B.S%2A4a.S%2A4c.4a3b%2B.4c3b.9d9c%2B.3c4d.4e4d.L%2A4e.4d4c%2B.4e4g%2B.4c3b.2b3b.3h4g.7f7g%2B.9c8c.B%2A6e.9h9b%2B.6e4g%2B.L%2A4h.P%2A4f.4h4g.4f4g%2B.P%2A4h.S%2A5h.4i3i.L%2A3h.3i3h.4g3h.2h3h.S%2A1g.B%2A5d.G%2A4c.5d4c%2B.3b4c.L%2A4f.N%2A4d.2i1g.B%2A5g.S%2A5e.G%2A5d.R%2A4a.4c3c.5e4d#34" }
    end

    it "コピー" do
      first(".KifCopyButton").click
      assert_text("コピーしました")
    end

    it "詳細" do
      first(".DetailButton").click
      assert { current_path == "/swars/battles/devuser3-Yamada_Taro-20200101_123403/" }
    end
  end

  describe "ACTION" do
    it "プレイヤー情報" do
      visit2 "/swars/search", query: "Yamada_Taro"
      side_menu_open
      find(".swars_users_key_handle").click
      assert { current_path == "/swars/users/Yamada_Taro/" }
    end
  end

  describe "表示形式" do
    describe "テーブルカラムのトグル" do
      it "最初に検索したとき日付のカラムがある" do
        visit2 "/swars/search", query: "Yamada_Taro"
        table_in { assert_text("2020-01-01") }
      end

      it "日時のカラムを非表示にする" do
        visit2 "/swars/search", query: "Yamada_Taro"
        side_menu_open
        
        find(".is_layout_table .dropdown").click
        menu_item_sub_menu_click("日時")

        table_in { assert_no_text("2020-01-01") }
      end

      it "保存している" do
        visit2 "/swars/search", query: "Yamada_Taro"
        side_menu_open
        find(".is_layout_table .dropdown").click
        menu_item_sub_menu_click("日時")

        visit2 "/swars/search", query: "Yamada_Taro"
        assert_list_present
        table_in { assert_no_text("2020-01-01") }
      end
    end

    describe "切り替え" do
      it "初期値は一覧になっている" do
        visit2 "/swars/search", query: "Yamada_Taro"
        assert_selector(".SwarsBattleIndexTable")        
      end

      it "一覧から盤面に切り替える" do
        visit2 "/swars/search", query: "Yamada_Taro"
        side_menu_open
        find(".is_layout_board").click
        assert_selector(".SwarsBattleIndexBoard")
      end

      it "盤面の局面を切り替える" do
        visit2 "/swars/search", query: "Yamada_Taro"
        side_menu_open
        find(".is_layout_board").click
        assert_var_eq(:display_key, "last")
      end
    end
  end

  describe "表示オプション" do
    describe "表示件数" do
      it "初期値は10になっている" do
        visit2 "/swars/search"
        assert_var_eq(:per, 10)
        assert_var_eq(:records_length, 0)
      end

      it "サイドバーから変更できる" do
        visit2 "/swars/search", query: "Yamada_Taro"
        side_menu_open
        find(".per_change_menu_item").click
        find(".is_per1").click
        assert_var_eq(:per, 1)
        assert_var_eq(:records_length, 1)
      end

      xit "保存している(実装後に有効にする)" do
        visit2 "/swars/search", query: "Yamada_Taro"
        side_menu_open
        find(".per_change_menu_item").click
        find(".is_per1").click

        visit2 "/swars/search", query: "Yamada_Taro"
        assert_var_eq(:per, 1)
        assert_var_eq(:records_length, 1)
      end
    end

    describe "フィルタ" do
      it "サイドバーから変更できる" do
        visit2 "/swars/search", query: "Yamada_Taro"
        side_menu_open
        find(".filter_set_menu_item").click
        find(".query_preset_judge_win").click # 「勝ち」
        assert_var_eq(:records_length, 0)
      end
    end

    describe "対戦相手で絞る" do
      it "サイドバーから変更できる" do
        visit2 "/swars/search", query: "Yamada_Taro"
        side_menu_open
        find(".vs_input_modal_handle").click
        within(".VsInputModal") do
          find("input").set("devuser1")
          find(".apply_handle").click
        end
        assert_no_selector(".VsInputModal")
        assert_var_eq(:records_length, 1)
      end
    end
  end

  describe "一括取得" do
    describe "ダウンロード" do
      it "ログインしていない場合はSNS経由ログインモーダル発動" do
        visit2 "/swars/direct-download"
        assert_selector(".NuxtLoginContainer")
      end

      it "正しくダウンロードできる" do
        login_by :sysop

        visit2 "/swars/search", query: "Yamada_Taro"
        side_menu_open
        find(".swars_direct_download_handle").click         # 「ダウンロード」をタップ
        assert { current_path == "/swars/direct-download" } # 遷移した

                                                            # ページ遷移後
        find(".swars_zip_dl_logs_destroy_all").click        # 「クリア」
        find(".oldest_log_create_handle").click             # 「古い1件をDLしたことにする」
        find(".zdsk_continue").click                        # 「前回の続きから」
        find(".download_handle").click                      # 「ダウンロード」

        assert { current_path == "/swars/search" }          # 検索に戻った
      end
    end

    describe "古い棋譜を補完" do
      it "ログインしていない場合はSNS経由ログインモーダル発動" do
        visit2 "/swars/users/Yamada_Taro/download-all"
        assert_selector(".NuxtLoginContainer")
      end

      it "正しく予約できる" do
        login_by :sysop

        visit2 "/swars/search", query: "Yamada_Taro"
        side_menu_open
        find(".swars_users_key_download_all_handle").click # 「古い棋譜を補完」をタップ
        assert { current_path == "/swars/users/Yamada_Taro/download-all" }

                                                           # ページ遷移後
        find(".crawler_run_handle_handle").click           # 「さばく」
        find(".attachment_mode_switch_handle").click       # 「ZIPファイルの添付」
        find(".post_handle").click                         # 「棋譜取得の予約」

                                                           # モーダル発動
        assert_text("予約しました(0件待ち)")
        find(".dialog.modal.is-active button").click       # 「OK」をクリック

        find(".crawler_run_handle_handle").click           # 「さばく」
        assert_text("取得処理実行完了(1→0)")
      end
    end
  end

  describe "便利な使い方あれこれ" do
    describe "検索初期値の設定" do
      it "検索初期値を設定してあるので引数なしで来たのに結果が出ている" do
        visit2 "/swars/search", query: "Yamada_Taro"
        default_swars_id_set

        visit2 "/swars/search"
        assert_list_present
      end

      it "検索初期値を解除したので引数なしで来たときは検索できない" do
        visit2 "/swars/search", query: "Yamada_Taro"
        assert_query "Yamada_Taro"
        default_swars_id_set   # 検索初期値に Yamada_Taro を設定

        visit2 "/swars/search" # 再度検索ページに飛ぶと Yamada_Taro で検索している
        assert_query "Yamada_Taro"
        assert_list_present

        default_swars_id_unset # 検索初期値の Yamada_Taro を解除
        visit2 "/swars/search"
        assert_query ""
        assert_list_blank    # 何も検索されていない
      end
    end

    describe "ホーム画面に追加" do
      it "works" do
        visit2 "/swars/search", query: "Yamada_Taro"
        side_menu_open
        find(".home_bookmark_handle").click
        assert_selector(".dialog.modal.is-active")
        text_click("わかった")
      end
    end

    describe "外部APPショートカット" do
      before do
        visit2 "/swars/search", query: "Yamada_Taro"
        side_menu_open
        find(".external_app_menu_item").click
      end

      it "ぴよ将棋" do
        find(".is_external_app_piyo_shogi").click
        assert { current_path == "/swars/users/Yamada_Taro/direct-open/piyo_shogi/" }
      end

      it "KENTO" do
        find(".is_external_app_kento").click
        assert { current_path == "/swars/users/Yamada_Taro/direct-open/kento/" }
      end
    end

    describe "KENTO_API" do
      it "works" do
        visit2 "/swars/search", query: "Yamada_Taro"
        side_menu_open
        find(".swars_users_key_kento_api_menu_item").click

        # 移動後
        assert { current_path == "/swars/users/Yamada_Taro/kento-api" } # 別ページに移動した
        assert_text("Yamada_Taroさん専用の KENTO API 設定手順")         # タイトルが正しい
        find(".clipboard_copy_handle").click                            # 「URLをコピー」をクリック
        find(".jump_to_kento_setting_handle").click                     # 「KENTO側で設定」の「移動」をクリック
        assert { windows.count == 2 }                                   # 別タブが開かれたため2つになった
        assert { current_url.include?("localhost") }                    # URLは変わっていない
        switch_to_window(windows.last)                                  # タブを切り替える
        assert { current_url.include?("kento-shogi.com") }              # KENTOに移動している
      end
    end
  end

  def default_swars_id_set
    side_menu_open
    menu_item_click("検索初期値の設定")
    find(".set_handle").click
  end

  def default_swars_id_unset
    side_menu_open
    menu_item_click("検索初期値の設定")
    find(".unset_handle").click
  end

  def assert_list_blank
    assert_no_text("ぴよ将棋")
  end

  def assert_list_present
    assert_text "1-3 / 3"
    assert_text "Yamada_Taro 四段"
    assert_text("ぴよ将棋")
  end

  def assert_query(query)
    value = find("#query").value
    assert { value == query }
  end

  def assert_var_eq(var, val)
    within(".system_test_variables") do
      assert_text("[#{var}=#{val}]")
    end
  end

  def table_in
    within(".SwarsBattleIndexTable") { yield }
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> |----+--------------------------------------+---------------------------+----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------+-------------+----------+-----------+---------------------------+------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------+------------+---------------+---------------+------------+---------------------------+---------------------------+------------------+-----------------+--------------------+---------------+----------------|
# >> | id | key                                  | battled_at                | rule_key | csa_seq                                                                                                                                                                                                                                                             | final_key | win_user_id | turn_max | meta_info | accessed_at               | preset_key | sfen_body                                                                                                                                                                                                                                                           | sfen_hash                        | start_turn | critical_turn | outbreak_turn | image_turn | created_at                | updated_at                | defense_tag_list | attack_tag_list | technique_tag_list | note_tag_list | other_tag_list |
# >> |----+--------------------------------------+---------------------------+----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------+-------------+----------+-----------+---------------------------+------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------+------------+---------------+---------------+------------+---------------------------+---------------------------+------------------+-----------------+--------------------+---------------+----------------|
# >> |  1 | devuser1-Yamada_Taro-20200101_123401 | 2020-01-01 12:34:01 +0900 | ten_min  | [["+5756FU", 600], ["-8384FU", 599], ["+7776FU", 598], ["-8485FU", 598], ["+8877KA", 597], ["-6152KI", 597], ["+2858HI", 595], ["-7162GI", 588], ["+7968GI", 594], ["-5142OU", 588], ["+6857GI", 593], ["-4232OU", 586], ["+5948OU", 592], ["-1314FU", 579], ["+... | TORYO     |           1 |      109 | {}        | 2021-12-08 20:09:58 +0900 | 平手       | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 5g5f 8c8d 7g7f 8d8e 8h7g 6a5b 2h5h 7a6b 7i6h 5a4b 6h5g 4b3b 5i4h 1c1d 1g1f 6c6d 5f5e 6b6c 5g5f 3a4b 4h3h 4c4d 3h2h 4b4c 3i3h 7c7d 9g9f 9c9d 9i9g 3c3d 4g4f 2b3c 5h9h 8e8f 8g... | d1df9c82d90fffa58b462b38dbe2b4a1 |            |            34 |            43 |            | 2021-12-08 20:09:58 +0900 | 2021-12-08 20:09:58 +0900 |                  |                 |                    |               |                |
# >> |  2 | devuser2-Yamada_Taro-20200101_123402 | 2020-01-01 12:34:02 +0900 | ten_min  | [["+5756FU", 600], ["-8384FU", 599], ["+7776FU", 598], ["-8485FU", 598], ["+8877KA", 597], ["-6152KI", 597], ["+2858HI", 595], ["-7162GI", 588], ["+7968GI", 594], ["-5142OU", 588], ["+6857GI", 593], ["-4232OU", 586], ["+5948OU", 592], ["-1314FU", 579], ["+... | TORYO     |           3 |      109 | {}        | 2021-12-08 20:09:58 +0900 | 平手       | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 5g5f 8c8d 7g7f 8d8e 8h7g 6a5b 2h5h 7a6b 7i6h 5a4b 6h5g 4b3b 5i4h 1c1d 1g1f 6c6d 5f5e 6b6c 5g5f 3a4b 4h3h 4c4d 3h2h 4b4c 3i3h 7c7d 9g9f 9c9d 9i9g 3c3d 4g4f 2b3c 5h9h 8e8f 8g... | d1df9c82d90fffa58b462b38dbe2b4a1 |            |            34 |            43 |            | 2021-12-08 20:09:58 +0900 | 2021-12-08 20:09:58 +0900 |                  |                 |                    |               |                |
# >> |  3 | devuser3-Yamada_Taro-20200101_123403 | 2020-01-01 12:34:03 +0900 | ten_min  | [["+5756FU", 600], ["-8384FU", 599], ["+7776FU", 598], ["-8485FU", 598], ["+8877KA", 597], ["-6152KI", 597], ["+2858HI", 595], ["-7162GI", 588], ["+7968GI", 594], ["-5142OU", 588], ["+6857GI", 593], ["-4232OU", 586], ["+5948OU", 592], ["-1314FU", 579], ["+... | TORYO     |           4 |      109 | {}        | 2021-12-08 20:09:59 +0900 | 平手       | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 5g5f 8c8d 7g7f 8d8e 8h7g 6a5b 2h5h 7a6b 7i6h 5a4b 6h5g 4b3b 5i4h 1c1d 1g1f 6c6d 5f5e 6b6c 5g5f 3a4b 4h3h 4c4d 3h2h 4b4c 3i3h 7c7d 9g9f 9c9d 9i9g 3c3d 4g4f 2b3c 5h9h 8e8f 8g... | d1df9c82d90fffa58b462b38dbe2b4a1 |            |            34 |            43 |            | 2021-12-08 20:09:59 +0900 | 2021-12-08 20:09:59 +0900 |                  |                 |                    |               |                |
# >> |----+--------------------------------------+---------------------------+----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------+-------------+----------+-----------+---------------------------+------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------+------------+---------------+---------------+------------+---------------------------+---------------------------+------------------+-----------------+--------------------+---------------+----------------|
# >> .
# >>
# >> Top 1 slowest examples (3.32 seconds, 53.8% of total time):
# >>   将棋ウォーズ棋譜検索 入っているデータの確認
# >>     3.32 seconds -:6
# >>
# >> Finished in 6.17 seconds (files took 3.6 seconds to load)
# >> 1 example, 0 failures
# >>
