require "rails_helper"

RSpec.describe "棋譜用紙", type: :system do
  include SwarsSupport

  it "棋譜用紙" do
    visit2 "/swars/battles/devuser2-Yamada_Taro-20200101_123402/formal-sheet"
    assert_text "記録係"
    doc_image
  end

  # xit "棋譜用紙(デバッグ)" do
  #   visit2 "/swars/battles/#{record.to_param}", formal_sheet: true, formal_sheet_debug: true
  #   assert_text "記録係"
  #   doc_image
  # end
  #
  # xit "レイアウト崩れの原因を伝えるダイアログ表示" do
  #   visit2 "/swars/battles/#{record.to_param}?formal_sheet=true"
  #   click_on("レイアウトが崩れていませんか？")
  #   assert_text "最小フォントサイズ"
  #   doc_image
  # end
end
