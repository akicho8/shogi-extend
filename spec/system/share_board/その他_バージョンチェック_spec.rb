require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "最新" do
    @API_VERSION = AppConfig[:share_board_api_version]
    window_a do
      visit_room(user_name: :alice, API_VERSION: @API_VERSION)
      assert_no_text("新しいプログラムがあるのでブラウザをリロードします")
    end
  end

  it "更新" do
    @API_VERSION = AppConfig[:share_board_api_version] + 1
    window_a do
      visit_room(user_name: :alice, API_VERSION: @API_VERSION)
      assert_text("新しいプログラムがあるのでブラウザをリロードします")
      buefy_dialog_button_click
    end
  end
end
