require "#{__dir__}/helper"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(user_name)
    visit_room({
        :user_name                   => user_name,
        :FIXED_MEMBER                => "a,b",
        :FIXED_ORDER                 => "a",
        :think_mark_invite_feature_p => true,
      })

    browser_audio_wakeup
  end

  # ここ Puma の問題かわらないけど3つタブを開くと音がならなくなる
  it "works" do
    window_a { case1(:a) }
    window_b { case1(:b) }
    window_a { clock_start }
    window_b { Capybara.assert_selector(".modal") }      # 観戦者だけに出ている
    window_a { Capybara.assert_no_selector(".modal") }   # 対局者には表示されていない
  end
end
