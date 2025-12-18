require "#{__dir__}/../sb_support_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(params)
    visit_app({ **clock_box_params(params), autoexec: :cc_auto_start, clock_speed: 60 })
  end

  def assert_extra_koreyori_true
    Capybara.within(".SingleClock0") { assert_var(:extra_koreyori_count, 1) }
  end

  def assert_extra_koreyori_false
    Capybara.within(".SingleClock0") { assert_var(:extra_koreyori_count, 0) }
  end

  it "持ち時間があって秒読みがない場合も考慮時間に入ったとき発動する" do
    case1([1, 0, 30, 0])
    assert_extra_koreyori_true
  end

  it "秒読みがあって考慮時間に入ったときに発動する" do
    case1([0, 1, 30, 0])
    assert_extra_koreyori_true
  end

  it "フィッシャールールでも発動する" do
    case1([0, 1, 30, 1])
    assert_extra_koreyori_true
  end

  it "考慮時間が残っていないときは発動しない" do
    case1([0, 1, 0, 0])
    cc_timeout_modal_close
    assert_extra_koreyori_false
  end

  it "いきなり考慮時間の場合は発動しない" do
    case1([0, 0, 30, 0])
    assert_extra_koreyori_false
  end
end
