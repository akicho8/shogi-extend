require "rails_helper"

RSpec.describe "詳細", type: :system, swars_spec: true do
  include SwarsSystemSupport

  before do
    @key = "devuser1-Yamada_Taro-20200101_123401"
  end

  describe "HTML" do
    it "HTMLで表示する" do
      visit2 "/swars/battles/#{@key}"
      assert_text "Yamada_Taro"
      assert_text "最後は投了"
    end
  end

  describe "画像" do
    it "画像でも表示する" do
      visit2 "/swars/battles/#{@key}.png"
      assert_current_path "/swars/battles/#{@key}.png", ignore_query: true
    end

    it "画像を反転して最後の局面を表示する" do
      visit2 "/swars/battles/#{@key}.png", turn: -1, viewpoint: "white"
      assert_current_path "/swars/battles/#{@key}.png", ignore_query: true
    end
  end

  describe "棋譜" do
    describe "表示" do
      it "KIF" do
        visit2 "/swars/battles/#{@key}"
        hamburger_click
        find(".menu_item_show").click
        find(".menu_item_show .kif_utf8").click
        switch_to_window_last
        assert_text "手数----指手---------消費時間--"
      end
    end
    describe "コピー" do
      it "KIF" do
        visit2 "/swars/battles/#{@key}"
        hamburger_click
        find(".menu_item_copy").click
        find(".menu_item_copy .kif_utf8").click
        assert_text "コピーしました"
      end
    end
    describe "ダウンロード" do
      it "KIF" do
        visit2 "/swars/battles/#{@key}"
        hamburger_click
        find(".menu_item_dl").click
        find(".menu_item_dl .kif_utf8").click
        assert_text "たぶんダウンロードしました"
      end
    end
  end
end
