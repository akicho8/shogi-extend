require "rails_helper"

RSpec.describe "その他", type: :system do
  it "トップ" do
    visit "/"
    expect(page).to have_content "Rails"
  end

  it "符号入力ゲーム" do
    visit "/xy"
    expect(page).to have_content "Rails"
  end
end
