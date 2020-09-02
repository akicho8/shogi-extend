require "rails_helper"

RSpec.describe "なんでも棋譜変換", type: :system do
  it "フォームを開く" do
    visit "/adapter"
    expect(page).to have_content "なんでも棋譜変換"
    doc_image
  end

  it "正常系" do
    visit "/adapter"
    find("textarea").set("68S")
    find(".kif_copy_button").click
    expect(page).to have_content "コピーしました"
    doc_image
  end

  it "エラー" do
    visit "/adapter"
    find("textarea").set("11玉")
    find(".kif_copy_button").click
    expect(page).to have_content "駒の上に打とうとしています"
    doc_image
  end

  it "オプション" do
    visit "/adapter"
    option_click
    expect(page).to have_content "盤面"
    doc_image
  end

  # http://0.0.0.0:3000/adapter?body=foo
  it "bodyパラメータで棋譜を渡せる" do
    visit "/adapter?body=(foo)"
    value = find("textarea").value
    assert { value == "(foo)" }
    doc_image
  end

  it "KIF変換表示" do
    assert_convert("68銀", "まで1手で先手の勝ち")
  end

  describe "shogidb2" do
    it "指定局面のURLをパースする" do
      assert_convert("https://shogidb2.com/games/018d3d1ee6594c34c677260002621417c8f75221#lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202", "まで0手で先手の勝ち")
    end

    it "参考図のURLをパースする" do
      assert_convert("https://shogidb2.com/board?sfen=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202&moves=-3334FU%2B2726FU-8384FU%2B2625FU-8485FU%2B5958OU-4132KI%2B6978KI-8586FU%2B8786FU-8286HI%2B2524FU-2324FU%2B2824HI-8684HI%2B0087FU-0023FU%2B2428HI-2233KA%2B5868OU-7172GI%2B9796FU-3142GI%2B8833UM", "まで0手で先手の勝ち")
    end
  end

  def assert_convert(kifu_body, result)
    visit "/adapter"
    option_click
    find("textarea").set(kifu_body)
    find(".kif_show_button").click
    ajax_waiting
    within_window(windows.last) do
      expect(page).to have_content result
      doc_image
    end
  end

  def option_click
    find("#option_switch").click
  end

  # これは絶対いる
  def ajax_waiting
    sleep(1.5)
  end
end
