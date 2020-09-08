require "rails_helper"

RSpec.describe "stopwatch", type: :system do
  it "stopwatch" do
    visit "http://localhost:4000/stopwatch"
    expect(page).to have_content "詰将棋RTA用ストップウォッチ"
    doc_image
  end
end
