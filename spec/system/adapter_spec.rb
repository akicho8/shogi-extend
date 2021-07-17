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

  # cd ~/src/shogi-extend/ && BROWSER_DEBUG=1 rspec ~/src/shogi-extend/spec/system/adapter_spec.rb -e 'エラー'
  it "エラー" do
    visit "/adapter"
    find("textarea").set("11玉")
    find(".KifCopyButton").click
    assert_text "駒の上に打とうとしています", wait: 10 # 開発時はエラーの場合にわざとsleepしているため長めに待つ
    doc_image
  end

  # http://localhost:3000/adapter?body=foo
  it "bodyパラメータで棋譜を渡せる" do
    visit "/adapter?body=(foo)"
    value = find("textarea").value
    assert { value == "(foo)" }
    doc_image
  end
end
