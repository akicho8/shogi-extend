require "rails_helper"

RSpec.describe "詳細", type: :system, swars_spec: true do
  include SwarsSystemSupport

  before do
    @key = "DevUser1-YamadaTaro-20200101_123401"
  end

  describe "HTML" do
    def case1(params = {})
      visit_to "/swars/battles/#{@key}", params
      assert_text "YamadaTaro", wait: 5
      assert_text "最後は時間切れ"
      assert_text "入玉宣言"
    end

    it "works" do
      case1
      case1 scene_key: "critical_turn"
    end
  end

  # BODだけ特殊で局面を反映するのでCSAなどよりBODのテストを優先で行う
  # というかこれがあれば他の形式のテストは不要
  describe "表示・コピー・ダウンロード" do
    before do
      visit_to "/swars/battles/#{@key}"
      find(".ShogiPlayer .button.first").click # 0手目
      find(".ShogiPlayer .button.next").click  # 1手目
      global_menu_open
    end
    it "棋譜表示" do
      menu_item_sub_menu_click("棋譜表示")
      switch_to_window_by { menu_item_click("BOD #1") }
      assert_text "手数＝1"
    end
    it "棋譜コピー" do
      menu_item_sub_menu_click("棋譜コピー")
      Clipboard.write("")
      menu_item_click("BOD #1")
      assert_clipboard("手数＝1")
    end
    it "棋譜ダウンロード" do
      menu_item_sub_menu_click("棋譜ダウンロード")
      file = Rails.root.join("tmp/#{@key}.bod")
      FileUtils.rm_f(file)
      menu_item_click("BOD #1")
      sleep(1) # 0.03 秒かかるため余裕を見て待つ
      assert { file.exist? }
      assert { file.read.include?("手数＝1") }
    end
  end

  describe "画像(共有将棋盤に飛ばすようにしたので普通の遷移では見れない)" do
    it "画像でも表示する" do
      visit_to "/swars/battles/#{@key}.png"
      assert_current_path "/swars/battles/#{@key}.png", ignore_query: true
    end

    it "画像を反転して最後の局面を表示する" do
      visit_to "/swars/battles/#{@key}.png", turn: -1, viewpoint: "white"
      assert_current_path "/swars/battles/#{@key}.png", ignore_query: true
    end
  end

  it "本家" do
    visit_to "/swars/battles/#{@key}"
    global_menu_open
    switch_to_window(window_opened_by { menu_item_click("本家") })
    assert { current_url == "https://shogiwars.heroz.jp/games/DevUser1-YamadaTaro-20200101_123401" }
  end

  describe "タイムチャート" do
    it "すべてのボタンが押せる" do
      visit_to "/swars/battles/#{@key}"
      Capybara.find("label", text: "明細", exact_text: true).click
      Capybara.find("label", text: "累積", exact_text: true).click
      Capybara.find("label", text: "-", exact_text: true).click
      Capybara.find("label", text: "+", exact_text: true).click
    end
    it "状態はブラウザに保存する" do
      # 両方をデフォルトでない方にする
      visit_to "/swars/battles/#{@key}"
      Capybara.find("label", text: "累積", exact_text: true).click
      Capybara.find("label", text: "+", exact_text: true).click
      # リロードして状態が同じになっているか確認する
      visit_to "/swars/battles/#{@key}"
      Capybara.assert_selector("label.is-selected", text: "累積", exact_text: true)
      Capybara.assert_selector("label.is-selected", text: "+", exact_text: true)
    end
  end

  it "開いたときスライダーにフォーカスしている" do
    visit_to "/swars/battles/#{@key}"
    assert_selector(".ShogiPlayer .b-slider-thumb", focused: true)
  end
end
