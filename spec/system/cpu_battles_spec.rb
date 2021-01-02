require "rails_helper"

RSpec.describe "CPU対戦", type: :system do
  it "トップ" do
    visit "http://localhost:4000/cpu-battle"
    expect(page).to have_content "強さ"
    doc_image
  end

  it "CPUの強さ変更" do
    visit "http://localhost:4000/cpu-battle"
    # choose("弱い")
    first(:xpath, "//span[text()='弱い']").click
    doc_image
  end

  it "対局" do
    visit "http://localhost:4000/cpu-battle"
    first(:xpath, "//span[text()='平手']").click
    first(:xpath, "//span[text()='ルールわかってない']").click
    first(:xpath, "//a[text()='対局開始']").click # click_on("対局開始") が動かないので

    # 1手目「79の銀を68に移動」
    first(".place_7_9").click
    first(".place_6_8").click
    doc_image("1手目")
    expect(page).to have_content "#2" # CPUがすぐに指したため2手になっている

    # 3手目「５一飛成」を指す
    if false
      first(".place_2_8").click
      first(".place_5_1").click
      doc_image("3手目")
      expect(page).to have_content "成りますか？"
      click_on("成る")

      expect(page).to have_content "反則負け"
      doc_image("反則負け")
    end
  end
end
