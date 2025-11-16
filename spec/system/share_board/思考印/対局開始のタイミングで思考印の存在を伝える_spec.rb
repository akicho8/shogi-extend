require "#{__dir__}/helper"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(user_name)
    visit_room({
        :user_name                   => user_name,
        :FIXED_MEMBER                => "a,b",
        :FIXED_ORDER                 => "a",
        :think_mark_invite_feature_p => true,
        :auto_close_p                => true,
      })

    browser_audio_wakeup
  end

  # ここ Puma の問題かわらないけど3つタブを開くと音がならなくなる
  it "works" do
    window_a { case1(:a) }
    window_b { case1(:b) }
    window_a do
      clock_open                # 対局時計を開いて
      clock_play_button_click   # 開始
    end
    window_a { assert_text("aさんの対局を1人みています") } # 対局者へ
    window_b { assert_text("観戦者のbさんへ") }            # 観戦者へ
  end
end
