require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(params)
    visit_app({**clock_box_params(params), clock_auto_start: "true", clock_speed: 60})
  end

  def assert_koreyori_true
    Capybara.within(".SingleClock0") { assert_system_variable(:koreyori_count, 1) }
  end

  def assert_koreyori_false
    Capybara.within(".SingleClock0") { assert_no_system_variable(:koreyori_count, 1) }
  end

  it "持ち時間があって秒読みに入ったときに発動する" do
    case1([1, 30, 0, 0])
    assert_koreyori_true
  end

  it "フィッシャールールでは持ち時間が回復して何度も呼ばれることになるので発動しない" do
    case1([1, 30, 0, 1])
    assert_koreyori_false
  end

  it "秒読みや猶予が残っていないときも発動しない" do
    case1([1, 0, 0, 0])
    assert_koreyori_false
  end
end
