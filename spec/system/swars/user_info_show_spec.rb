require "rails_helper"

RSpec.describe "プレイヤー情報", type: :system, swars_spec: true do
  include SwarsSystemSupport

  it "最初に開いたときのタブは日付になっている" do
    visit2 "/swars/users/YamadaTaro"
    assert_current_tab_at 0
  end

  it "引数でデフォルトのタブを変更する" do
    visit2 "/swars/users/YamadaTaro", tab_index: 1
    assert_current_tab_at 1
  end

  it "タブを変更する" do
    visit2 "/swars/users/YamadaTaro"

    tab_click_by_name("日付")
    within(".boxes") { assert_text "2020-01-01" }

    tab_click_by_name("段級")
    within(".boxes") { assert_text "三段" }

    tab_click_by_name("戦法")
    within(".boxes") { assert_text "対振り持久戦" }

    tab_click_by_name("対攻")
    within(".boxes") { assert_text "" }

    tab_click_by_name("囲い")
    within(".boxes") { assert_text "舟囲い" }

    tab_click_by_name("対囲")
    within(".boxes") { assert_text "高美濃囲い" }

    tab_click_by_name("他")
    within(".boxes") { assert_text "将棋ウォーズの運営を支える力" }
  end

  it "絞り込み" do
    visit "/swars/users/YamadaTaro"
    tab_click_by_name("他")

    find(".SwarsUserShowDropdownMenu").click # 右上「…」クリック
    find("span", text: "絞り込み").click
    # スピナー中
    assert_text("条件なし", wait: 5)
    find("label", text: "10分").click
    find(:button, text: "絞り込む").click
    assert_current_path "/swars/users/YamadaTaro/?tab_index=6&query=%E6%8C%81%E3%81%A1%E6%99%82%E9%96%93%3A10%E5%88%86"

    # 検索に戻ったとき絞り込み条件を持っていっている
    find(".PageCloseButton", wait: 5).click
    assert_selector(:fillable_field, type: "search", with: "YamadaTaro 持ち時間:10分")
  end

  it "commandを押しながらタブをクリックすると別タブで開く" do
    visit2 "/swars/users/YamadaTaro"
    window = Capybara.window_opened_by { tab_element("他").click(:meta) }
    Capybara.switch_to_window(window)
    within(".boxes") { assert_text "将棋ウォーズの運営を支える力" }
  end

  def assert_current_tab_at(index)
    assert_selector ".tabs li:nth-of-type(#{index.next}).is-active"
  end

  def tab_click_by_index(index)
    find(".tabs li:nth-of-type(#{index.next})").click
  end

  def tab_element(name)
    find(:xpath, "//*[text()='#{name}']")
  end

  def tab_click_by_name(name)
    tab_element(name).click
  end
end
