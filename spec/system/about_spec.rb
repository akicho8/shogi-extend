require "rails_helper"

RSpec.describe "about", type: :system do
  it "プライバシー" do
    visit "/about/privacy-policy"
    assert_text "プライバシー"
    doc_image
  end

  it "利用規約" do
    visit "/about/terms"
    assert_text "利用規約"
    doc_image
  end

  it "クレジット" do
    visit "/about/credit"
    assert_text "SHOGI APPS"
    doc_image
  end
end
