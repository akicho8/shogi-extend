require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(fixed_user_name)
    visit_app({
        :room_code            => :test_room,
        :fixed_user_name      => fixed_user_name,
        :fixed_member_names   => "a,b",
        :fixed_order_names    => "a,b",
        :handle_name_validate => "false",
      })
    find(".message_modal_handle").click
  end

  before do
    a_block { case1("a") }
    b_block { case1("b") }
  end

  it "/medal-user" do
    a_block do
      chat_message_send("/medal-user b +2")
      assert_member_has_text("b", "⭐⭐")

      chat_message_send("/medal-user b -1")
      assert_member_has_text("b", "⭐")
    end

    b_block do
      assert_member_has_text("b", "⭐")
    end
  end

  it "/medal-team" do
    a_block do
      chat_message_send("/medal-team white +1")
      debugger
      assert_member_has_text("b", "⭐")
    end
    b_block do
      assert_member_has_text("b", "⭐")
    end
  end
end
