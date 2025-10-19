require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(user_name)
    visit_room({
        :user_name         => user_name,
        :fixed_member      => "a,b",
        :fixed_order       => "a,b",
        :auto_resign_key   => :is_auto_resign_on,
        :room_after_create => :cc_auto_start_10m,
      })
    give_up_modal_open_handle   # 投了モーダルを表示した状態にする
  end

  it "works" do
    window_a { case1(:a) }
    window_b { case1(:b) }
    window_a { find(".GiveUpModal .cc_timeout_trigger").click } # a が時間切れになる
    window_a { assert_no_give_up_modal }                        # 時間切れになったことで投了モーダルが閉じられている
    window_b { assert_no_give_up_modal }                        # 時間切れになったことで投了モーダルが閉じられている
  end
end
