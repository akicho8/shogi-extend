require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(user_name)
    visit_app({
        :room_key            => :test_room,
        :user_name            => user_name,
        :fixed_member_names   => "alice,bob",
        :fixed_order_names    => "alice,bob",
        :handle_name_validate => "false",
        :fixed_order_state    => "to_o2_state",
        :auto_resign_key      => "is_auto_resign_on",
        :autoexec => "cc_auto_start",
      })
  end

  it "works" do
    a_block do
      case1("alice")
      give_up_modal_open_handle                                # 投了モーダルを表示した状態にする
    end
    b_block do
      case1("bob")
      give_up_modal_open_handle                                # 投了モーダルを表示した状態にする
    end
    a_block do
      find(".GiveUpModal .cc_timeout_trigger").click # alice が時間切れになる
    end
    a_block do
      assert_no_give_up_modal                           # 時間切れになったことで投了モーダルが閉じられている
    end
    b_block do
      assert_no_give_up_modal                           # 時間切れになったことで投了モーダルが閉じられている
    end
  end
end
