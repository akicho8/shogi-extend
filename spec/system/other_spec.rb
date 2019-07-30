require "rails_helper"

RSpec.describe "その他", type: :system do
  it "トップ" do
    visit "/"
    expect(page).to have_content "Rails"
    doc_image
  end

  it "符号入力ゲーム" do
    visit "/xy"
    expect(page).to have_content "Rails"
    doc_image
  end

  it "ストップウォッチ" do
    visit "/stopwatch"
    expect(page).to have_content "Rails"
    doc_image
  end

  it "局面編集" do
    visit "/position-editor"
    expect(page).to have_content "Rails"
    doc_image
  end

  describe "戦法トリガー事典" do
    it "一覧" do
      visit "/tactics"
      expect(page).to have_content "Rails"
      doc_image
    end

    describe "詳細" do
      it "囲い" do
        visit "/tactics/ダイヤモンド美濃"
        expect(page).to have_content "ダイヤモンド美濃"
        doc_image
      end

      it "戦型" do
        visit "/tactics/富沢キック"
        expect(page).to have_content "ポンポン桂"
        doc_image
      end

      it "手筋" do
        visit "/tactics/パンツを脱ぐ"
        expect(page).to have_content "パンツを脱ぐ"
        doc_image
      end
    end

    it "戦法ツリー" do
      visit "/tactics-tree"
      expect(page).to have_content "Rails"
      doc_image
    end

    it "今日の戦法占い" do
      visit "/tactics-fortune"
      expect(page).to have_content "Rails"
      doc_image
    end
  end
end
