require "rails_helper"

RSpec.describe "将棋ウォーズ棋譜検索", type: :system, swars_spec: true do
  include SwarsSystemSupport

  describe "始めて来た" do
    it "引数なしで来たときの画面" do
      visit_to "/swars/search"
      assert_text "将棋ウォーズ棋譜検索"
      assert_query ""
      assert_list_blank
    end
  end

  describe "クエリ検索" do
    it "検索フォームに入力して検索する" do
      visit_to "/swars/search"
      fill_in "query", with: "YamadaTaro"
      assert_query "YamadaTaro"
      find(".search_click_handle").click
      assert_list_present
    end

    it "謎の空白が混入するBiDi問題" do
      visit_to "/swars/search"
      fill_in "query", with: "\u{202A}YamadaTaro\u{202C}"
      find(".search_click_handle").click
      assert_list_present
    end

    describe "検索クエリ内各パラメータ" do
      it "ウォーズIDだけを指定する" do
        visit_to "/swars/search", query: "YamadaTaro"
        assert_query "YamadaTaro"
        assert_list_present
      end

      it "相手で絞る" do
        visit_to "/swars/search", query: "YamadaTaro vs:DevUser2"
        assert_var_eq(:records_length, 1)
      end

      it "囲い名で絞る" do
        visit_to "/swars/search", query: "YamadaTaro tag:舟囲い"
        assert_var_eq(:records_length, 3)

        visit_to "/swars/search", query: "YamadaTaro tag:高美濃囲い"
        assert_var_eq(:records_length, 0)
      end
    end

    describe "入力補完" do
      def case1(query, complement_user_keys)
        search_by(query)
        visit_to "/swars/search" # 一度リロードする
        assert_var_eq(:complement_user_keys, complement_user_keys, wait: 5)
      end

      it "順番が正しい" do
        visit_to "/swars/search", complement_user_keys: "c b a" # 初期値を設定しておくと
        assert_var_eq(:complement_user_keys, "c|b|a")         # Rails側からのコピーをかわせる

        case1 :DevUser1, "DevUser1|c|b"                       # DevUser1が直近に登場
        case1 :DevUser2, "DevUser2|DevUser1|c"                # DevUser2が先頭に入ったが最大3件なのでaが溢れた
        case1 :DevUser3, "DevUser3|DevUser2|DevUser1"         # DevUser3が先頭に入ったが最大3件なのでbが溢れた
      end

      it "クエリ全体を取り込む" do
        visit_to "/swars/search", complement_user_keys: "xxx"                   # 初期値を設定しておくと
        assert_var_eq(:complement_user_keys, "xxx")                           # Rails側からのコピーをかわせる
        search_by "　DevUser1　tag:a,b　手数:>=1　"                           # 入力が汚なくても
        # complement_user_keys_prepend_key に影響して切り替わる
        if false
          assert_var_eq(:complement_user_keys, "DevUser1 tag:a,b 手数:>=1|xxx") # squishして取り込んでいる
        else
          assert_var_eq(:complement_user_keys, "DevUser1|xxx")                  # 取り込むのはウォーズIDだけ
        end
      end
    end

    describe "検索クエリを自力入力しすぎ警告" do
      it "works" do
        visit "/swars/search" # visit_to では __SYSTEM_TEST_RUNNING__ がつくのでダメ

        # DevUser1 で9回
        fill_in "query", with: "DevUser1"
        9.times { find(".search_click_handle").click }
        assert_var_eq(:tiresome_previous_user_key, "DevUser1")
        assert_var_eq(:tiresome_count, 9)

        # YamadaTaro で1回で計10回になるがカウンタをリセットするので発動しない
        fill_in "query", with: "YamadaTaro"
        find(".search_click_handle").click
        assert_var_eq(:tiresome_previous_user_key, "YamadaTaro")
        assert_var_eq(:tiresome_count, 1)

        # +9回で計10回になり発動する
        9.times { find(".search_click_handle").click }
        assert_text "ところでウォーズID入力するの面倒じゃない？", wait: 5

        find(".dialog.modal.is-active button.is-info").click # 「わかった」をクリック
        assert_no_selector ".modal"
      end
    end
  end

  describe "一覧要素の一番上の対局の各操作ボタンをクリックする" do
    before do
      visit_to "/swars/search", query: "YamadaTaro"
    end

    it "ぴよ将棋" do
      el = first(".PiyoShogiButton")
      assert { el[:href].start_with?("piyoshogi://") }
    end

    it "KENTO" do
      switch_to_window_by { first(".KentoButton").click }
      assert { current_url.start_with?("https://www.kento-shogi.com/") }
    end

    it "KIF形式の棋譜コピー" do
      table_in { first(".kif_copy").click }
      assert_text "コピーしました"
      assert_clipboard(/^手数/)
    end

    it "詳細" do
      first(".ShowButton").click
      assert_current_path "/swars/battles/DevUser3-YamadaTaro-20200101_123403/", ignore_query: true
    end
  end

  describe "ACTION" do
    it "プレイヤー情報" do
      visit_to "/swars/search", query: "YamadaTaro 持ち時間:10分"
      sidebar_open
      find(".swars_users_key_handle").click
      if false
        assert_current_path "/swars/users/YamadaTaro/?query=%E6%8C%81%E3%81%A1%E6%99%82%E9%96%93%3A10%E5%88%86&tab_index=0"
      else
        assert_current_path "/swars/users/YamadaTaro/?tab_index=0"
      end
    end
  end

  describe "表示形式" do
    describe "テーブルカラムのトグル" do
      it "最初に検索したとき日付のカラムがある" do
        visit_to "/swars/search", query: "YamadaTaro"
        table_in { assert_text("2020-01-01") }
      end

      it "日時のカラムを非表示にする" do
        visit_to "/swars/search", query: "YamadaTaro"
        sidebar_open

        column_toggle_menu_open
        menu_item_sub_menu_click("日時")

        table_in { assert_no_text("2020-01-01") }
      end

      it "保存している" do
        visit_to "/swars/search", query: "YamadaTaro"
        sidebar_open
        column_toggle_menu_open
        menu_item_sub_menu_click("日時")

        visit_to "/swars/search", query: "YamadaTaro"
        assert_list_present
        table_in { assert_no_text("2020-01-01") }
      end
    end

    describe "切り替え" do
      it "初期値は一覧になっている" do
        visit_to "/swars/search", query: "YamadaTaro"
        assert_selector(".SwarsBattleIndexTable")
      end

      it "一覧から盤面に切り替える" do
        visit_to "/swars/search", query: "YamadaTaro"
        sidebar_open
        find(".is_layout_board").click
        assert_selector(".SwarsBattleIndexBoard")
        assert_var_eq(:scene_key, "critical_turn") # 盤面の局面の初期値
      end

      it "盤面を開戦から終局に変更する" do
        visit_to "/swars/search", query: "YamadaTaro"
        sidebar_open
        find(".is_layout_board").click
        find(".is_scene_turn_max").click
        assert_var_eq(:scene_key, "turn_max")
      end

      describe "別タブで開く系" do
        it "commandを押しながら盤面をクリックすると別タブで開く" do
          visit_to "/swars/search", query: "YamadaTaro"
          sidebar_open
          window = window_opened_by(wait: 10) { find(".is_layout_board").click(:meta) }
          switch_to_window(window)
          assert_selector(".SwarsBattleIndexBoard", wait: 10)
        end

        it "commandを押しながら終局をクリックすると別タブで開く" do
          visit_to "/swars/search", query: "YamadaTaro"
          sidebar_open
          window = window_opened_by(wait: 10) { find(".is_scene_turn_max").click(:meta) }
          switch_to_window(window)
          assert_var_eq(:scene_key, "turn_max")
        end
      end
    end
  end

  describe "表示オプション" do
    describe "表示件数" do
      it "初期値は10になっている" do
        visit_to "/swars/search"
        assert_var_eq(:per, 10)
        assert_var_eq(:records_length, 0)
      end

      it "サイドバーから変更する" do
        visit_to "/swars/search", query: "YamadaTaro"
        sidebar_open
        find(".per_change_menu_item").click
        find(".is_per1").click
        assert_var_eq(:per, 1)
        assert_var_eq(:records_length, 1)
      end

      it "保存している" do
        visit_to "/swars/search", query: "YamadaTaro"
        sidebar_open
        find(".per_change_menu_item").click
        find(".is_per1").click

        visit_to "/swars/search", query: "YamadaTaro"
        assert_var_eq(:per, 1)
        assert_var_eq(:records_length, 1)
      end
    end
  end

  describe "まとめて取得" do
    xdescribe "ダウンロード" do
      it "ログインしていない場合はSNS経由ログインモーダル発動" do
        visit_to "/swars/direct-download"
        assert_selector(".NuxtLoginContainer")
      end

      it "正しくダウンロードする" do
        login_by :admin

        visit_to "/swars/search", query: "YamadaTaro"
        sidebar_open
        find(".swars_direct_download_handle").click         # 「ダウンロード」をクリック
        assert_current_path "/swars/direct-download", ignore_query: true

        # ページ遷移後
        find(".swars_zip_dl_logs_destroy_all").click        # 「クリア」
        find(".one_record_download_for_debug_handle").click             # 「古い1件をDLしたことにする」
        find(".continue").click                        # 「前回の続きから」
        find(".download_handle").click                      # 「ダウンロード」

        # switch_to_window(windows.first)                     # 自力で戻る
        # assert_text "将棋ウォーズ棋譜検索"                  # 検索に戻った
      end
    end

    xdescribe "古い棋譜の補完" do
      it "ログインしていない場合はSNS経由ログインモーダル発動" do
        visit_to "/swars/users/YamadaTaro/download-all"
        assert_selector(".NuxtLoginContainer", wait: 30)
      end

      it "正しく予約する" do
        login_by :admin

        visit_to "/swars/search", query: "YamadaTaro"
        sidebar_open
        find(".swars_users_key_download_all_handle").click # 「古い棋譜の補完」をクリック
        assert_current_path "/swars/users/YamadaTaro/download-all", ignore_query: true

        # ページ遷移後
        find(".crawler_run_handle_handle").click           # 「さばく」
        find(".attachment_mode_switch_handle").click       # 「ZIPファイルの添付」
        find(".post_handle").click                         # 「棋譜取得の予約」

        # モーダル発動
        assert_text("予約しました(0件待ち)", wait: 10)
        find(".dialog.modal.is-active button").click       # 「OK」をクリック

        find(".crawler_run_handle_handle").click           # 「さばく」
        assert_text("取得処理実行完了(1→0)")
      end
    end
  end

  describe "一歩進んだ使い方" do
    describe "ウォーズIDを記憶する" do
      it "検索初期値を設定してあるので引数なしで来たのに結果が出ている" do
        visit_to "/swars/search", query: "YamadaTaro"
        default_swars_id_set

        visit_to "/swars/search"
        assert_list_present
      end

      it "検索初期値を解除したので引数なしで来たときは検索できない" do
        visit_to "/swars/search", query: "YamadaTaro"
        assert_query "YamadaTaro"
        default_swars_id_set   # 検索初期値に YamadaTaro を設定

        visit_to "/swars/search" # 再度検索ページに飛ぶと YamadaTaro で検索している
        assert_query "YamadaTaro"
        assert_list_present

        default_swars_id_unset # 検索初期値の YamadaTaro を解除
        visit_to "/swars/search"
        assert_query ""
        assert_list_blank    # 何も検索されていない
      end
    end

    describe "ホーム画面に追加" do
      it "works" do
        visit_to "/swars/search", query: "YamadaTaro"
        sidebar_open
        find(".home_bookmark_handle").click
        assert_selector(".dialog.modal.is-active")
        text_click("わかった")
      end
    end

    describe "外部APPショートカット" do
      before do
        visit_to "/swars/search", query: "YamadaTaro"
        sidebar_open
        find(".external_app_menu_item").click
      end

      it "ぴよ将棋" do
        find(".is_external_app_piyo_shogi").click
        assert_current_path "/swars/users/YamadaTaro/direct-open/piyo_shogi/", ignore_query: true
      end

      it "KENTO" do
        find(".is_external_app_kento").click
        assert_current_path "/swars/users/YamadaTaro/direct-open/kento/", ignore_query: true
      end
    end

    describe "KENTO_API" do
      it "works" do
        visit_to "/swars/search", query: "YamadaTaro"
        sidebar_open
        find(".swars_users_key_kento_api_menu_item").click

        # 移動後
        assert_current_path "/swars/users/YamadaTaro/kento-api", ignore_query: true
        assert_text("YamadaTaroさん専用の KENTO API 設定手順")         # タイトルが正しい
        find(".clipboard_copy_handle").click                            # 「URLをコピー」をクリック
        switch_to_window_by do
          find(".jump_to_kento_setting_handle").click                     # 「KENTO側で設定」の「移動」をクリック
        end
        assert { current_url.include?("kento-shogi.com") }              # KENTOに移動している
      end
    end
  end

  describe "棋譜のファイル保存" do
    it "works" do
      visit_to "/swars/search", query: "YamadaTaro"
      sidebar_open
      column_toggle_menu_open
      menu_item_sub_menu_click("保存 (UTF-8)")
      sidebar_close
      table_in { first(".kif_save_as_utf8").click }
      assert_text "たぶんダウンロードしました"
    end
  end

  describe "KI2形式の棋譜コピー" do
    it "works" do
      visit_to "/swars/search", query: "YamadaTaro"
      sidebar_open
      column_toggle_menu_open
      menu_item_sub_menu_click("コピー (KI2)")
      sidebar_close
      table_in { first(".ki2_copy").click }
      assert_text "コピーしました"
      assert_clipboard(/^▲/)
    end
  end

  def default_swars_id_set
    sidebar_open
    find(".swars_default_user_key_set_handle").click
    find(".post_handle").click
  end

  def default_swars_id_unset
    sidebar_open
    find(".swars_default_user_key_set_handle").click
    find("#form_part-swars_search_default_key").set("")
    find(".post_handle").click
  end

  def assert_list_blank
    assert_no_text("ぴよ将棋")
  end

  def assert_list_present
    assert_text "1-3 / 3", wait: 5
    assert_text "YamadaTaro四段"
    assert_text "ぴよ将棋"
  end

  def assert_query(query)
    assert_selector(:fillable_field, id: "query", with: query)
  end

  def assert_var_eq(var, val, options = {})
    within(".system_test_variables") do
      assert_text("[#{var}=#{val}]", **options)
    end
  end

  def table_in
    within(".SwarsBattleIndexTable") { yield }
  end

  def search_by(query)
    fill_in "query", with: query
    find(".search_click_handle").click
  end

  def column_toggle_menu_open
    find(".is_layout_table .dropdown").click
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> |----+--------------------------------------+---------------------------+----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------+-------------+----------+-----------+---------------------------+------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------+------------+---------------+---------------+------------+---------------------------+---------------------------+------------------+-----------------+--------------------+---------------+----------------|
# >> | id | key                                  | battled_at                | rule_key | csa_seq                                                                                                                                                                                                                                                             | final_key | win_user_id | turn_max | meta_info | accessed_at               | preset_key | sfen_body                                                                                                                                                                                                                                                           | sfen_hash                        | start_turn | critical_turn | outbreak_turn | image_turn | created_at                | updated_at                | defense_tag_list | attack_tag_list | technique_tag_list | note_tag_list | other_tag_list |
# >> |----+--------------------------------------+---------------------------+----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------+-------------+----------+-----------+---------------------------+------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------+------------+---------------+---------------+------------+---------------------------+---------------------------+------------------+-----------------+--------------------+---------------+----------------|
# >> |  1 | DevUser1-YamadaTaro-20200101_123401 | 2020-01-01 12:34:01 +0900 | ten_min  | [["+5756FU", 600], ["-8384FU", 599], ["+7776FU", 598], ["-8485FU", 598], ["+8877KA", 597], ["-6152KI", 597], ["+2858HI", 595], ["-7162GI", 588], ["+7968GI", 594], ["-5142OU", 588], ["+6857GI", 593], ["-4232OU", 586], ["+5948OU", 592], ["-1314FU", 579], ["+... | TORYO     |           1 |      109 | {}        | 2021-12-08 20:09:58 +0900 | 平手       | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 5g5f 8c8d 7g7f 8d8e 8h7g 6a5b 2h5h 7a6b 7i6h 5a4b 6h5g 4b3b 5i4h 1c1d 1g1f 6c6d 5f5e 6b6c 5g5f 3a4b 4h3h 4c4d 3h2h 4b4c 3i3h 7c7d 9g9f 9c9d 9i9g 3c3d 4g4f 2b3c 5h9h 8e8f 8g... | d1df9c82d90fffa58b462b38dbe2b4a1 |            |            34 |            43 |            | 2021-12-08 20:09:58 +0900 | 2021-12-08 20:09:58 +0900 |                  |                 |                    |               |                |
# >> |  2 | DevUser2-YamadaTaro-20200101_123402 | 2020-01-01 12:34:02 +0900 | ten_min  | [["+5756FU", 600], ["-8384FU", 599], ["+7776FU", 598], ["-8485FU", 598], ["+8877KA", 597], ["-6152KI", 597], ["+2858HI", 595], ["-7162GI", 588], ["+7968GI", 594], ["-5142OU", 588], ["+6857GI", 593], ["-4232OU", 586], ["+5948OU", 592], ["-1314FU", 579], ["+... | TORYO     |           3 |      109 | {}        | 2021-12-08 20:09:58 +0900 | 平手       | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 5g5f 8c8d 7g7f 8d8e 8h7g 6a5b 2h5h 7a6b 7i6h 5a4b 6h5g 4b3b 5i4h 1c1d 1g1f 6c6d 5f5e 6b6c 5g5f 3a4b 4h3h 4c4d 3h2h 4b4c 3i3h 7c7d 9g9f 9c9d 9i9g 3c3d 4g4f 2b3c 5h9h 8e8f 8g... | d1df9c82d90fffa58b462b38dbe2b4a1 |            |            34 |            43 |            | 2021-12-08 20:09:58 +0900 | 2021-12-08 20:09:58 +0900 |                  |                 |                    |               |                |
# >> |  3 | DevUser3-YamadaTaro-20200101_123403 | 2020-01-01 12:34:03 +0900 | ten_min  | [["+5756FU", 600], ["-8384FU", 599], ["+7776FU", 598], ["-8485FU", 598], ["+8877KA", 597], ["-6152KI", 597], ["+2858HI", 595], ["-7162GI", 588], ["+7968GI", 594], ["-5142OU", 588], ["+6857GI", 593], ["-4232OU", 586], ["+5948OU", 592], ["-1314FU", 579], ["+... | TORYO     |           4 |      109 | {}        | 2021-12-08 20:09:59 +0900 | 平手       | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 5g5f 8c8d 7g7f 8d8e 8h7g 6a5b 2h5h 7a6b 7i6h 5a4b 6h5g 4b3b 5i4h 1c1d 1g1f 6c6d 5f5e 6b6c 5g5f 3a4b 4h3h 4c4d 3h2h 4b4c 3i3h 7c7d 9g9f 9c9d 9i9g 3c3d 4g4f 2b3c 5h9h 8e8f 8g... | d1df9c82d90fffa58b462b38dbe2b4a1 |            |            34 |            43 |            | 2021-12-08 20:09:59 +0900 | 2021-12-08 20:09:59 +0900 |                  |                 |                    |               |                |
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
