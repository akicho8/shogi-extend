require "#{__dir__}/../shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app
    clock_open
    Capybara.within(".preset_dropdown") do
      find(".preset_dropdown_button").click       # プリセットを開く
      find(".dropdown-item:nth-of-type(1)").click # 一番上の「ウォーズ10分」を適用
    end
    clock_box_form_eq(:black, 10, 0, 0, 0)    # 設定されている
  end
end
