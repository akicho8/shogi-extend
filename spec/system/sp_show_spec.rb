require "rails_helper"

RSpec.describe "sp_show", type: :system do
  it "棋譜コピー" do
    visit "/adapter"
    find(".sp_show_button").click
    find(".modal-card .kif_copy_button").click
    expect(page).to have_content "コピーしました"
    doc_image
  end
end
