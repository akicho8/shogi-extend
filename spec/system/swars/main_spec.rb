require "rails_helper"

RSpec.describe "将棋ウォーズ棋譜検索", type: :system, swars_spec: true do
  include SwarsSupport

  # let :record do
  #   Swars::Battle.first
  # end

  it "入っているデータの確認" do
    assert { Swars::Battle.count == 3 }
    if $0 == __FILE__
      tp Swars::Battle
      # >> |----+--------------------------------------+---------------------------+----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------+-------------+----------+-----------+---------------------------+------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------+------------+---------------+---------------+------------+---------------------------+---------------------------+------------------+-----------------+--------------------+---------------+----------------|
      # >> | id | key                                  | battled_at                | rule_key | csa_seq                                                                                                                                                                                                                                                             | final_key | win_user_id | turn_max | meta_info | accessed_at               | preset_key | sfen_body                                                                                                                                                                                                                                                           | sfen_hash                        | start_turn | critical_turn | outbreak_turn | image_turn | created_at                | updated_at                | defense_tag_list | attack_tag_list | technique_tag_list | note_tag_list | other_tag_list |
      # >> |----+--------------------------------------+---------------------------+----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------+-------------+----------+-----------+---------------------------+------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------+------------+---------------+---------------+------------+---------------------------+---------------------------+------------------+-----------------+--------------------+---------------+----------------|
      # >> |  1 | devuser1-Yamada_Taro-20200101_123401 | 2020-01-01 12:34:01 +0900 | ten_min  | [["+5756FU", 600], ["-8384FU", 599], ["+7776FU", 598], ["-8485FU", 598], ["+8877KA", 597], ["-6152KI", 597], ["+2858HI", 595], ["-7162GI", 588], ["+7968GI", 594], ["-5142OU", 588], ["+6857GI", 593], ["-4232OU", 586], ["+5948OU", 592], ["-1314FU", 579], ["+... | TORYO     |           1 |      109 | {}        | 2021-12-05 15:18:23 +0900 | 平手       | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 5g5f 8c8d 7g7f 8d8e 8h7g 6a5b 2h5h 7a6b 7i6h 5a4b 6h5g 4b3b 5i4h 1c1d 1g1f 6c6d 5f5e 6b6c 5g5f 3a4b 4h3h 4c4d 3h2h 4b4c 3i3h 7c7d 9g9f 9c9d 9i9g 3c3d 4g4f 2b3c 5h9h 8e8f 8g... | d1df9c82d90fffa58b462b38dbe2b4a1 |            |            34 |            43 |            | 2021-12-05 15:18:23 +0900 | 2021-12-05 15:18:23 +0900 |                  |                 |                    |               |                |
      # >> |  2 | devuser2-Yamada_Taro-20200101_123402 | 2020-01-01 12:34:02 +0900 | ten_min  | [["+5756FU", 600], ["-8384FU", 599], ["+7776FU", 598], ["-8485FU", 598], ["+8877KA", 597], ["-6152KI", 597], ["+2858HI", 595], ["-7162GI", 588], ["+7968GI", 594], ["-5142OU", 588], ["+6857GI", 593], ["-4232OU", 586], ["+5948OU", 592], ["-1314FU", 579], ["+... | TORYO     |           3 |      109 | {}        | 2021-12-05 15:18:24 +0900 | 平手       | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 5g5f 8c8d 7g7f 8d8e 8h7g 6a5b 2h5h 7a6b 7i6h 5a4b 6h5g 4b3b 5i4h 1c1d 1g1f 6c6d 5f5e 6b6c 5g5f 3a4b 4h3h 4c4d 3h2h 4b4c 3i3h 7c7d 9g9f 9c9d 9i9g 3c3d 4g4f 2b3c 5h9h 8e8f 8g... | d1df9c82d90fffa58b462b38dbe2b4a1 |            |            34 |            43 |            | 2021-12-05 15:18:24 +0900 | 2021-12-05 15:18:24 +0900 |                  |                 |                    |               |                |
      # >> |  3 | devuser3-Yamada_Taro-20200101_123403 | 2020-01-01 12:34:03 +0900 | ten_min  | [["+5756FU", 600], ["-8384FU", 599], ["+7776FU", 598], ["-8485FU", 598], ["+8877KA", 597], ["-6152KI", 597], ["+2858HI", 595], ["-7162GI", 588], ["+7968GI", 594], ["-5142OU", 588], ["+6857GI", 593], ["-4232OU", 586], ["+5948OU", 592], ["-1314FU", 579], ["+... | TORYO     |           4 |      109 | {}        | 2021-12-05 15:18:24 +0900 | 平手       | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 5g5f 8c8d 7g7f 8d8e 8h7g 6a5b 2h5h 7a6b 7i6h 5a4b 6h5g 4b3b 5i4h 1c1d 1g1f 6c6d 5f5e 6b6c 5g5f 3a4b 4h3h 4c4d 3h2h 4b4c 3i3h 7c7d 9g9f 9c9d 9i9g 3c3d 4g4f 2b3c 5h9h 8e8f 8g... | d1df9c82d90fffa58b462b38dbe2b4a1 |            |            34 |            43 |            | 2021-12-05 15:18:24 +0900 | 2021-12-05 15:18:24 +0900 |                  |                 |                    |               |                |
      # >> |----+--------------------------------------+---------------------------+----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------+-------------+----------+-----------+---------------------------+------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------+------------+---------------+---------------+------------+---------------------------+---------------------------+------------------+-----------------+--------------------+---------------+----------------|
    end
  end

  describe "クエリ検索" do
    it "引数なしで来たときの画面" do
      visit2 "/swars/search"
      assert_text "将棋ウォーズ棋譜検索"
      assert_query ""
      assert_list_blank
    end

    it "検索フォームに入力して検索する" do
      visit2 "/swars/search"
      assert_query ""
      fill_in "query", with: "Yamada_Taro"
      assert_query "Yamada_Taro"
      find(".search_click_handle").click
      assert_list_present
    end

    it "引数に指定して検索する" do
      visit2 "/swars/search", query: "Yamada_Taro"
      assert_query "Yamada_Taro"
      assert_list_present
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
        find(".display_key_set_table_handle .dropdown").click
        menu_item_sub_menu_click("日時")
        table_in { assert_no_text("2020-01-01") }
      end
    end

    describe "切り替え" do
      it "初期値はテーブルになっている" do
        visit2 "/swars/search", query: "Yamada_Taro"
        assert_var_eq(:display_key, "table")
      end

      it "表示形式を切り替える" do
        visit2 "/swars/search", query: "Yamada_Taro"
        side_menu_open

        find(".display_key_set_critical_handle").click
        assert_var_eq(:display_key, "critical")
        assert_selector(".is_board_display")

        find(".display_key_set_outbreak_handle").click
        assert_var_eq(:display_key, "outbreak")
        assert_selector(".is_board_display")

        find(".display_key_set_last_handle").click
        assert_var_eq(:display_key, "last")
        assert_selector(".is_board_display")

        find(".display_key_set_table_handle").click
        assert_var_eq(:display_key, "table")
        assert_selector(".SwarsBattleIndexTable")
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
    end

    describe "フィルタ" do
      it "サイドバーから変更できる" do
        visit2 "/swars/search", query: "Yamada_Taro"
        side_menu_open
        find(".filter_set_menu_item").click
        find(".is_filter_judge_win").click
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
    assert_text("[#{var}=#{val}]")
  end

  def table_in
    within(".SwarsBattleIndexTable") { yield }
  end
end
