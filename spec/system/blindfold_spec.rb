require "rails_helper"

RSpec.describe "目隠し詰将棋", type: :system do
  it "最初" do
    visit "/blindfold"
    assert_text "目隠し詰将棋"
    doc_image
  end

  it "棋譜の読み込み" do
    visit "/blindfold"
    hamburger_click
    menu_item_click("棋譜の読み込み")
    find(".AnySourceReadModal textarea").set("68S", clear: :backspace)
    find(".AnySourceReadModal .submit_handle").click
    assert_text "棋譜を読み込みました"
  end
end
