require "rails_helper"

RSpec.describe "奨励会三段リーグ", type: :system do
  it "例会" do
    visit "/three-stage-leagues"
    expect(page).to have_content "奨励会三段リーグ"
    doc_image

    visit "/three-stage-leagues/28"
    expect(page).to have_content "第28期"
    doc_image
  end

  it "個人成績" do
    visit "/three-stage-league-players/伊藤匠"
    expect(page).to have_content "伊藤匠"
    doc_image
  end
end
