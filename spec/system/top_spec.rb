require "rails_helper"

RSpec.describe "トップ", type: :system do
  it "works" do
    visit "/"
    assert_text "About"
  end
end
