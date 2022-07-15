require "rails_helper"

RSpec.describe "奨励会三段リーグ", type: :system do
  it "例会" do
    visit "/three-stage-leagues"
    assert_text "奨励会三段リーグ"

    visit "/three-stage-leagues/28"
    assert_text "第28期"
  end

  it "個人成績" do
    visit "/three-stage-league-players/伊藤匠"
    assert_text "伊藤匠"
  end
end
