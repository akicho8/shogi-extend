require "rails_helper"

RSpec.describe "CPU対戦", type: :system do
  it "トップ" do
    visit_to "/cpu-battle"
    assert_text "強さ"
  end

  it "CPUの強さ変更" do
    visit_to "/cpu-battle"
    # choose("弱い")
    first(:xpath, "//span[text()='弱い']").click
  end

  it "対局" do
    visit_to "/cpu-battle"
    first(:xpath, "//span[text()='平手']").click
    first(:xpath, "//span[text()='ルールわかってない']").click
    find(".start_handle").click                  # 対局開始

    # 1手目「79の銀を68に移動」
    first(".place_7_9").click
    first(".place_6_8").click
    assert_text "#2" # CPUがすぐに指したため2手になっている

    # 3手目「５一飛成」を指す
    if false
      first(".place_2_8").click
      first(".place_5_1").click
      first(".promote_on_button").click
      # assert_text "成りますか？"
      # click_on("成る")
      assert_text "反則負け"
    end
  end
end
