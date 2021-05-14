require "rails_helper"

RSpec.describe "stopwatch", type: :system do
  it "stopwatch" do
    visit "/stopwatch"
    assert_text "詰将棋用ストップウォッチ"
    doc_image
  end
end
