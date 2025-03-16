require "rails_helper"

RSpec.describe "対局時計", type: :system do
  it "開く" do
    visit2 "/vs-clock"
    assert_text "持ち時間"
  end

  it "プリセットを設定する" do
    visit2 "/vs-clock"
    find(".cc_preset_dropdown").click
    assert_text "ウォーズ 10分"
    first(".dropdown-item").click
    assert_text "持ち時間"      # alert が出てない
  end
end
