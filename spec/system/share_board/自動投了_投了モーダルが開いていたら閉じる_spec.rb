require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(user_name)
    visit_room({
        :user_name            => user_name,
        :fixed_member   => "a,b",
        :fixed_order    => "a,b",
        :fixed_order_state    => "to_o2_state",
        :auto_resign_key      => "is_auto_resign_on",
        :room_after_create => :cc_auto_start_10m,
      })
  end

  it "works" do
    window_a do
      case1(:a)
      give_up_modal_open_handle                                # 投了モーダルを表示した状態にする
    end
    window_b do
      case1(:b)
      give_up_modal_open_handle                                # 投了モーダルを表示した状態にする
    end
    window_a do
      find(".GiveUpModal .cc_timeout_trigger").click # a が時間切れになる
    end
    window_a do
      assert_no_give_up_modal                           # 時間切れになったことで投了モーダルが閉じられている
    end
    window_b do
      assert_no_give_up_modal                           # 時間切れになったことで投了モーダルが閉じられている
    end
  end
end
