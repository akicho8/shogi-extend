require "rails_helper"

RSpec.describe "about", type: :system do
  it "プライバシー" do
    visit "/about/privacy-policy"
    expect(page).to have_content "プライバシー"
    doc_image
  end

  it "利用規約" do
    visit "/about/terms"
    expect(page).to have_content "利用規約"
    doc_image
  end

  it "クレジット" do
    visit "/about/credit"
    expect(page).to have_content "SHOGI APPS"
    doc_image
  end
end
