require "rails_helper"

RSpec.describe "about", type: :system do
  it "プライバシー" do
    visit2 "/about/privacy-policy"
    assert_text "プライバシー"
  end

  it "利用規約" do
    visit2 "/about/terms"
    assert_text "利用規約"
  end

  it "クレジット" do
    visit2 "/about/credit"
    assert_text "THANKS"
  end
end
