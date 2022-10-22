require "rails_helper"

RSpec.describe type: :system, login_spec: true do
  it "works" do
    login_by :sysop
    visit2 "/users/1", fake: true
    hamburger_click
    menu_item_click("退会")
    find(:button, "退会する").click
    assert_text "退会しました"
  end
end
