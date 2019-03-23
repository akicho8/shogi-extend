require "rails_helper"

RSpec.describe "CPUと練習対局", type: :system do
  it "トップ" do
    visit "/cpu/battles"
    expect(page).to have_content "CPUの強さ"
    doc_image
  end

  it "CPUの強さ変更" do
    visit "/cpu/battles"
    choose("弱い")
    doc_image
  end

  it "対局" do
    visit "/cpu/battles"

    # 1手目「79の銀を68に移動」
    first(".place_79").click
    first(".place_68").click
    doc_image("1手目")
    sleep(0.5)
    expect(page).to have_content "2手目" # CPUがすぐに指したため2手目になっている

    # 3手目「５一飛成」を指す
    first(".place_28").click
    first(".place_51").click
    sleep(0.5)
    doc_image("3手目")
    expect(page).to have_content "成りますか？"
    click_on("成る")
    sleep(0.5)

    expect(page).to have_content "反則負け"
    doc_image("反則負け")
  end
end
