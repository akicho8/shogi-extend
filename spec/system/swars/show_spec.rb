require "rails_helper"

RSpec.describe "詳細", type: :system, swars_spec: true do
  include SwarsSystemSupport

  before do
    @key = "devuser1-Yamada_Taro-20200101_123401"
  end

  describe "HTML" do
    def case1(params = {})
      visit2 "/swars/battles/#{@key}", params
      assert_text "Yamada_Taro"
      assert_text "最後は投了"
    end

    it "works" do
      case1
      case1 scene_key: "critical_turn"
    end
  end

  describe "棋譜" do
    before do
      visit2 "/swars/battles/#{@key}"
      hamburger_click
    end
    it "コピー" do
      menu_item_sub_menu_click("棋譜コピー")
      menu_item_click("CSA")
      assert_text "コピーしました"
    end
    it "表示" do
      menu_item_sub_menu_click("棋譜表示")
      switch_to_window_by { menu_item_click("CSA") }
      assert_text "%TORYO"
    end
    it "ダウンロード" do
      file = Rails.root.join("tmp/#{@key}.csa")
      FileUtils.rm_f(file)
      menu_item_sub_menu_click("棋譜ダウンロード")
      menu_item_click("CSA")
      assert { file.exist? }
    end
  end

  describe "BODだけ特殊で盤の手数の局面になる" do
    it "works" do
      visit2 "/swars/battles/#{@key}"
      find(".ShogiPlayer .button.first").click # 0手目
      find(".ShogiPlayer .button.next").click  # 1手目
      hamburger_click
      menu_item_sub_menu_click("棋譜表示")
      switch_to_window_by { menu_item_click("BOD #1") }
      assert_text "手数＝1"
    end
  end

  describe "画像(共有将棋盤に飛ばすようにしたので普通の遷移では見れない)" do
    it "画像でも表示する" do
      visit2 "/swars/battles/#{@key}.png"
      assert_current_path "/swars/battles/#{@key}.png", ignore_query: true
    end

    it "画像を反転して最後の局面を表示する" do
      visit2 "/swars/battles/#{@key}.png", turn: -1, viewpoint: "white"
      assert_current_path "/swars/battles/#{@key}.png", ignore_query: true
    end
  end
end
