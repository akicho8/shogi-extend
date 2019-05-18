require "rails_helper"

RSpec.describe "2ch棋譜", type: :system do
  before do
    general_battle_setup
  end

  it "トップ" do
    visit "/s"
    expect(page).to have_content "2ch棋譜検索"
    expect(page).to have_field "query"
    doc_image
  end
end
