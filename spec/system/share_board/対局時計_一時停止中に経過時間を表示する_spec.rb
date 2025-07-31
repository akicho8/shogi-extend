require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_app(clock_speed: 60, autoexec: "cc_create,cc_modal_open_handle")

    # 対局開始から一時停止で経過時間を表示する

    find(".play_button").click
    assert_selector(".clock_box_human_status", text: "動作中", exact_text: true)

    find(".pause_button").click
    assert_selector(".clock_box_human_status", text: "一時停止中", exact_text: true)

    assert_selector(".clock_box_pause_sec_human", text: /1:/)
    assert_text("1分経過")
    assert_selector(".clock_box_pause_sec_human", text: /2:/)
    assert_text("2分経過")

    # 再開から一時停止しても経過時間は0からカウントを始める

    find(".resume_button").click
    assert_selector(".clock_box_human_status", text: "動作中", exact_text: true)

    find(".pause_button").click
    assert_selector(".clock_box_human_status", text: "一時停止中", exact_text: true)

    assert_selector(".clock_box_pause_sec_human", text: /1:/)
    assert_selector(".clock_box_pause_sec_human", text: /2:/)
  end
end
