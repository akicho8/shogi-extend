require "rails_helper"

RSpec.describe "棋譜用紙", type: :system, swars_spec: true do
  include SwarsSystemSupport

  it "必要な情報を表示している" do
    visit_to "/swars/battles/DevUser1-YamadaTaro-20200101_123401/formal-sheet"
    assert_text "YamadaTaro"
    assert_text "記録係"
    assert_text "後手時間切れ"
    assert_text "109手で DevUser1 三段の勝ち"
    assert_text "2020年1月1日12時34分"
  end

  it "デバッグモード" do
    visit_to "/swars/battles/DevUser1-YamadaTaro-20200101_123401/formal-sheet", formal_sheet_debug: true
    assert_text "９九成香左上"
  end

  describe "オプション" do
    before do
      visit_to "/swars/battles/DevUser1-YamadaTaro-20200101_123401/formal-sheet"
      Capybara.execute_script("document.querySelector('.formal_sheet_workspace').remove()") # 邪魔してボタンが押せないので取る
    end

    it "プリンターダイアログ起動" do
      assert_selector(:button, :class => "printer_handle")
    end

    it "フォントを切り替える" do
      find(:label, text: "明朝", exact_text: true).click
      find(:label, text: "ゴシック", exact_text: true).click
    end

    it "文字サイズの変更" do
      find(".b-numberinput .control.minus").click
      assert_selector(:fillable_field, type: "number", with: "99")
    end

    it "使い方" do
      find("a", :class => "usage_dialog_show_handle").click
      assert_selector(".modal-card-title", text: "使い方や注意点", exact_text: true)
      find(:button, text: "OK", exact_text: true).click
      assert_no_selector(".dialog.modal")
    end
  end
end
