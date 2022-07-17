require "rails_helper"

RSpec.describe "トップ", type: :system do
  it "works" do
    visit2 "/"
    assert_text "About"
  end
end
