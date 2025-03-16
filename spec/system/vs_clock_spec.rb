require "rails_helper"

RSpec.describe "対局時計", type: :system do
  it "開く" do
    visit2 "/vs-clock"
    assert_text "持ち時間"
  end
end
