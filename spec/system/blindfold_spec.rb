require "rails_helper"

RSpec.describe "目隠し詰将棋", type: :system do
  it "最初" do
    visit "/blindfold"
    expect(page).to have_content "目隠し詰将棋"
    doc_image
  end
end
