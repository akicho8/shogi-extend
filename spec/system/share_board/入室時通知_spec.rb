require "#{__dir__}/sb_support_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def common_options
    {
      :room_url_copy_modal_p     => true,
      :room_url_copy_modal_delay => 0.5, # a の存在を b に通知するまでの時間がかかるため 0 だと b にもモーダルが出てしまう
    }
  end

  it "最初に来た人だけに通知が出る" do
    window_a do
      room_setup_by_user(:a, common_options)
      assert_member_exist(:a)
      assert_selector(".RoomUrlCopyModal") # a は最初に来たので通知が出る
    end
    window_b do
      room_setup_by_user(:b, common_options)
      assert_member_exist(:b)
      assert_member_exist(:a)
      assert_no_selector(".RoomUrlCopyModal") # b は次に来たので通知が出ない
    end
  end

  it "直接URLから来たら何も促さない" do
    visit_room(user_name: :a, **common_options)
    assert_no_selector(".RoomUrlCopyModal") # b は次に来たので通知が出ない
  end
end
