require "rails_helper"

RSpec.describe "stopwatch", type: :system do
  it "stopwatch" do
    visit_to "/stopwatch"
    assert_text "詰将棋用ストップウォッチ"
  end
end
