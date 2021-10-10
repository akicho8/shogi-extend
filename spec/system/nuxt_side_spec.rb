require "rails_helper"

RSpec.describe "システムテスト自体が動く", type: :system do
  it "works" do
    visit "/"
    assert_selector(".NavbarItemLogin")
  end
end
