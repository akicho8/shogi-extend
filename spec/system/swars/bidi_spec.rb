require "rails_helper"

RSpec.describe "BiDi問題", type: :system do
  before do
    swars_battle_setup
  end

  it "works" do
    visit "http://localhost:4000/swars/search"
    fill_in "query", with: "\u{202A}devuser1\u{202C}"
    find(".search_form_submit_button").click
    expect(page).to have_content "相手"
    doc_image
  end
end
