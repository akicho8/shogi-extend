require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(user_name)
    visit_room({
        :user_name         => user_name,
        :FIXED_MEMBER      => "a,b",
        :FIXED_ORDER       => "a,b",
        :room_after_create => :cc_auto_start_10m,
      })
    resign_confirm_modal_open_handle   # 投了モーダルを表示した状態にする
  end

  it "works" do
    window_a { case1(:a) }
    window_b { case1(:b) }
    window_a { find(".ResignConfirmModal .cc_timeout_trigger").click } # a が時間切れになる
    window_a { assert_no_resign_confirm_modal }                        # 時間切れになったことで投了モーダルが閉じられている
    window_b { assert_no_resign_confirm_modal }                        # 時間切れになったことで投了モーダルが閉じられている
  end
end
