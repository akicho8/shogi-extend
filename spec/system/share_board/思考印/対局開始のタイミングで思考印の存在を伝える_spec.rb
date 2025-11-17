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
    window_b do
      assert_text("観戦者のbさんへ")
      click_on("わかった")
      assert_no_selector(".dialog.modal")
    end
    window_a do
      assert_text("aさんの対局を1人みています")
      click_on("そんな余裕ないわ")
      assert_no_selector(".dialog.modal")
    end
  end
end
