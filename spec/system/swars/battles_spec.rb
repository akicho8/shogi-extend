require "rails_helper"

RSpec.describe "将棋ウォーズ棋譜検索", type: :system do
  before do
    swars_battle_setup
    @battle = Swars::Battle.first
  end

  describe "index" do
    it "トップ" do
      visit "/w"
      expect(page).to have_content "将棋ウォーズ棋譜検索"
      expect(page).to have_field "query"
      doc_image
    end

    it "通常検索" do
      visit "/w"
      fill_in "query", with: "devuser1"
      click_button "submit_button_for_test"
      expect(page).to have_content "相手"
      doc_image
    end

    it "ぴよ将棋専用" do
      visit "/w-light"
      fill_in "query", with: "devuser1"
      click_button "submit_button_for_test"
      expect(page).to have_content "相手"
      doc_image
    end

    it "アプリ起動できるブックマーク可能なページに飛ぶ" do
      visit "/w?query=devuser1"
      find(".usage_modal_open_handle").click
      find(".button.piyo_shogi").click
      doc_image("検索画面下の使い方表示")
      expect(page).to have_content "ホーム画面に追加してください"
      doc_image
    end

    it "ZIPダウンロード" do
      visit "/w?query=devuser1"
      find(".zip_dl_modal_open_handle").click
      doc_image("棋譜の種類を選択")
      find(".zip_dl_run").click
      doc_image
    end

    it "連打対策" do
      visit "/w?query=devuser1&raise_duplicate_key_error=1"
      expect(page).to have_content "データ収集中なのであと15秒ぐらいしてからお試しください"
      doc_image
    end

    it "仕掛けの局面表示" do
      visit "/w?query=devuser1&trick_show=true"
      expect(page).to have_content "終了図"
      doc_image
    end

    it "終了の局面表示" do
      visit "/w?query=devuser1&trick_show=true&end_show=true"
      expect(page).to have_content "終了図"
      doc_image
    end
  end

  describe "show" do
    it "詳細" do
      visit "/w/#{@battle.key}"
      expect(page).to have_content "消費時間"
      doc_image
    end

    it "棋譜用紙" do
      visit "/w/#{@battle.key}?formal_sheet=true"
      expect(page).to have_content "記録係"
      doc_image
    end

    it "棋譜用紙(デバッグ)" do
      visit "/w/#{@battle.key}?formal_sheet=true&formal_sheet_debug=true"
      expect(page).to have_content "記録係"
      doc_image
    end

    it "レイアウト崩れの原因を伝えるダイアログ表示" do
      visit "/w/#{@battle.key}?formal_sheet=true"
      click_on("レイアウトがおかしいですか？")
      expect(page).to have_content "最小フォントサイズ"
      doc_image
    end
  end
end
