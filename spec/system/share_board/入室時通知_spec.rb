require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def common_options
    {
      :room_url_copy_modal_p     => true,
      :room_url_copy_modal_delay => 0.5, # alice の存在を bob に通知するまでの時間がかかるため 0 だと bob にもモーダルが出てしまう
    }
  end

  it "最初に来た人だけに通知が出る" do
    window_a do
      room_setup_by_user(:alice, common_options)
      assert_member_exist(:alice)
      assert_selector(".RoomUrlCopyModal") # alice は最初に来たので通知が出る
    end
    window_b do
      room_setup_by_user(:bob, common_options)
      assert_member_exist(:bob)
      assert_member_exist(:alice)
      assert_no_selector(".RoomUrlCopyModal") # bob は次に来たので通知が出ない
    end
  end

  it "直接URLから来たら何も促さない" do
    visit_room(user_name: :alice, **common_options)
    assert_no_selector(".RoomUrlCopyModal") # bob は次に来たので通知が出ない
  end
end
