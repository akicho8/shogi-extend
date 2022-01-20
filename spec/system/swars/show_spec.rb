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
      assert { current_path == "/swars/battles/#{@key}.png" }
    end

    it "画像を反転して最後の局面を表示する" do
      visit2 "/swars/battles/#{@key}.png", turn: -1, viewpoint: "white"
      assert { current_path == "/swars/battles/#{@key}.png" }
    end
  end

  describe "棋譜" do
    describe "表示" do
      it "KIF" do
        visit2 "/swars/battles/#{@key}"
        hamburger_click
        menu_item_sub_menu_click("表示")
        menu_item_click("KIF")
        switch_to_window(windows.last)
        assert_text "手数----指手---------消費時間--"
      end
    end
    describe "コピー" do
      it "KIF" do
        visit2 "/swars/battles/#{@key}"
        hamburger_click
        menu_item_sub_menu_click("コピー")
        menu_item_click("KIF")
        assert_text "コピーしました"
      end
    end
    describe "ダウンロード" do
      it "KIF" do
        visit2 "/swars/battles/#{@key}"
        hamburger_click
        menu_item_sub_menu_click("ダウンロード")
        menu_item_click("KIF")
        assert_text "たぶんダウンロードしました"
      end
    end
  end
end
