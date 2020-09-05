require "rails_helper"

RSpec.describe "about", type: :system do
  it "プライバシー" do
    visit "http://localhost:4000/about/privacy-policy"
    expect(page).to have_content "プライバシー"
    doc_image
  end

  it "利用規約" do
    visit "http://localhost:4000/about/terms"
    expect(page).to have_content "利用規約"
    doc_image
  end

  it "クレジット" do
    visit "http://localhost:4000/about/credit"
    expect(page).to have_content "クレジット"
    doc_image
  end
end
