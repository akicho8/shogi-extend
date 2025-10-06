require "rails_helper"

RSpec.describe "トップ", type: :system do
  it "works" do
    visit_to "/"
    assert_text "About"
  end
end
