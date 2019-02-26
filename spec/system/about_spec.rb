require "rails_helper"

RSpec.describe "about", type: :system do
  it "プライバシー" do
    visit "/about/privacy_policy"
    expect(page).to have_content "Rails"
    doc_image
  end

  it "利用規約" do
    visit "/about/terms"
    expect(page).to have_content "Rails"
    doc_image
  end

  it "クレジット" do
    visit "/about/credit"
    expect(page).to have_content "Rails"
    doc_image
  end
end
