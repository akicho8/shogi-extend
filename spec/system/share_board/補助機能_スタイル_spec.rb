require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "モード変更" do
    visit_app
    sidebar_open
    find(".appearance_modal_open_handle").click
    find(:label, text: "モダン", exact_text: true).click
    find(:label, text: "リアル", exact_text: true).click
    find(:label, text: "ハイブリッド", exact_text: true).click
  end
end
