require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    initial_read_sec = 2
    visit_room({
        :user_name    => "a",
        :FIXED_MEMBER => "a,b",
        :FIXED_ORDER  => "a,b",
        **clock_box_params([0, initial_read_sec, 0, 0]),
      })
    clock_start
    sleep(initial_read_sec)     # initial_read_sec の秒読みが切れるまで待つ
    assert_timeout_modal_exist  # 時間切れモーダルを表示する
    cc_timeout_modal_close      # 時間切れモーダルを閉じる
    assert_order_off
  end
end
