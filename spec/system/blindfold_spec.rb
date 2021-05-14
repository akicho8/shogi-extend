require "rails_helper"

RSpec.describe "目隠し詰将棋", type: :system do
  it "最初" do
    visit "/blindfold"
    assert_text "目隠し詰将棋"
    doc_image
  end
end
