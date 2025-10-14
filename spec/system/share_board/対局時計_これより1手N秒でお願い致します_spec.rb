require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(params)
    visit_app({ **clock_box_params(params), autoexec: :cc_auto_start, clock_speed: 60 })
  end

  def assert_read_koreyori_true
    Capybara.within(".SingleClock0") { assert_var(:read_koreyori_count, 1) }
  end

  def assert_read_koreyori_false
    Capybara.within(".SingleClock0") { assert_var(:read_koreyori_count, 0) }
  end

  it "持ち時間があって秒読みに入ったときに発動する" do
    case1([1, 30, 0, 0])
    assert_read_koreyori_true
  end

  it "フィッシャールールでは持ち時間が回復して何度も呼ばれることになるので発動しない、ことにしていたが初回だけ発動するように変更した" do
    case1([1, 30, 0, 1])
    assert_read_koreyori_true
  end

  it "秒読みが残っていないときは発動しない" do
    case1([1, 0, 0, 0])
    assert_read_koreyori_false
  end
end
