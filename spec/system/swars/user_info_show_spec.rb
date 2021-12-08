require "rails_helper"

RSpec.describe "プレイヤー情報", type: :system, swars_spec: true do
  include SwarsSystemSupport

  it "最初に開いたときのタブは日付になっている" do
    visit2 "/swars/users/Yamada_Taro"
    assert_current_tab_at 0
  end

  it "引数でデフォルトのタブを変更できる" do
    visit2 "/swars/users/Yamada_Taro", tab_index: 1
    assert_current_tab_at 1
  end

  it "タブを変更する" do
    visit2 "/swars/users/Yamada_Taro"

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

  def assert_current_tab_at(index)
    assert_selector ".tabs li:nth-of-type(#{index.next}).is-active"
  end

  def tab_click_by_index(index)
    find(".tabs li:nth-of-type(#{index.next})").click
  end

  def tab_click_by_name(name)
    find(:xpath, "//*[text()='#{name}']").click
  end
end
