require "#{__dir__}/sb_support_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "最新" do
    @CLIENT_SIDE_API_VERSION = AppConfig[:share_board_api_version]
    window_a do
      visit_room(user_name: :a, CLIENT_SIDE_API_VERSION: @CLIENT_SIDE_API_VERSION)
      assert_no_selector(".modal")
    end
  end

  it "更新" do
    @CLIENT_SIDE_API_VERSION = AppConfig[:share_board_api_version] + 1
    window_a do
      visit_room(user_name: :a, CLIENT_SIDE_API_VERSION: @CLIENT_SIDE_API_VERSION)
      assert_selector(".modal .modal-card-title", text: "アプリ更新", exact_text: true)
      buefy_dialog_button_click
    end
  end
end
