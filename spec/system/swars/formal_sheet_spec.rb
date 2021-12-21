require "rails_helper"

RSpec.describe "棋譜用紙", type: :system, swars_spec: true do
  include SwarsSystemSupport

  it "必要な情報を表示している" do
    visit2 "/swars/battles/devuser1-Yamada_Taro-20200101_123402/formal-sheet"
    assert_text "Yamada_Taro"
    assert_text "記録係"
    assert_text "後手投了"
    assert_text "109手で devuser1 三段の勝ち"
    assert_text "2020年1月1日12時34分"
  end

  it "デバッグモード" do
    visit2 "/swars/battles/devuser1-Yamada_Taro-20200101_123402/formal-sheet", formal_sheet_debug: true
    assert_text "９九成香左上"
  end

  it "プリンターダイアログ起動" do
    visit2 "/swars/battles/devuser1-Yamada_Taro-20200101_123402/formal-sheet"
    assert_selector(".printer_handle")
  end

  it "フォントを切り替える" do
    visit2 "/swars/battles/devuser1-Yamada_Taro-20200101_123402/formal-sheet"
    find(".is_font_key_mincho").click
    doc_image "明朝体"
    find(".is_font_key_gothic").click
    doc_image "ゴシック体"
  end

  it "文字サイズの変更" do
    visit2 "/swars/battles/devuser1-Yamada_Taro-20200101_123402/formal-sheet"
    find(".b-numberinput .control.minus").click
    value = find(".b-numberinput .control input").value
    assert { value == "99" }
  end

  it "使い方" do
    visit2 "/swars/battles/devuser1-Yamada_Taro-20200101_123402/formal-sheet"
    find(".usage_dialog_show_handle").click
    assert_text "PDFに保存"
  end
end
