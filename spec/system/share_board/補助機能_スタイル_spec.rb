require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "モード変更" do
    visit_app
    sidebar_open
    find(:label, text: "ライト", exact_text: true).click
    find(:label, text: "ダーク", exact_text: true).click
    find(:label, text: "リアル", exact_text: true).click
  end
end
