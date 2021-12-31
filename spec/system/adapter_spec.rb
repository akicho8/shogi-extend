require "rails_helper"

RSpec.describe "なんでも棋譜変換", type: :system do
  it "フォームを開く" do
    visit "/adapter"
    assert_text "なんでも棋譜変換"
    doc_image
  end

  it "正常系" do
    visit "/adapter"
    find("textarea").set("68S")
    find(".KifCopyButton").click
    assert_text "コピーしました"
    doc_image
  end

  # http://localhost:3000/adapter?body=foo
  it "bodyパラメータで棋譜を渡せる" do
    visit "/adapter?body=(foo)"
    value = find("textarea").value
    assert { value == "(foo)" }
    doc_image
  end

  describe "エラー" do
    it "変な手を入力した" do
      visit "/adapter"
      find("textarea").set("11玉")
      find(".KifCopyButton").click
      assert_text "駒の上に打とうとしています", wait: 10 # 開発時はエラーの場合にわざとsleepしているため長めに待つ
      doc_image
    end

    it "指し手がおかしいときにエラーを出す" do
      visit "/adapter?body=58金"
      assert_text "失敗"
    end

    it "巨大なKIFを渡した場合にエラーを出す" do
      visit "/adapter?body=68S+active_record_value_too_long"
      assert_text "失敗"
    end
  end
end
