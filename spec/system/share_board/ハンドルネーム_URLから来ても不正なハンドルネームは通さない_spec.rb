require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "URLから来ても不正なハンドルネームは通さない" do
    visit_app({
        :room_key                   => :test_room,
        :user_name                  => "nanashi",
        :fixed_order                => "nanashi",
        :handle_name_validate_p       => true,
        :__visit_app_warning_skip__ => true,
      })
    assert_selector(".GateModal") # ハンドルネームが不正なのでダイアログが出ている
  end
end
