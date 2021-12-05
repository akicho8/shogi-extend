require "rails_helper"

RSpec.describe "将棋ウォーズ棋譜検索", type: :system do
  include SwarsSupport

  let :record do
    Swars::Battle.first
  end

  it "ダウンロード" do
    visit2 "/swars/direct-download", query: "Yamada_Taro", sort_column: "battled_at", sort_order: "desc"
    assert_text "ダウンロード"
    doc_image
  end

  describe "index" do
    # xit "アプリ起動できるブックマーク可能なページに飛ぶ" do
    #   visit2 "/swars/search?query=devuser1"
    #   find(".usage_modal_open_handle").click
    #   find(".usage_modal .piyo_shogi_button").click
    #   doc_image("検索画面下の使い方表示")
    #   assert_text "ホーム画面に追加してください"
    #   doc_image
    # end

    # xit "ZIPダウンロード" do
    #   visit2 "/swars/search?query=devuser1"
    #   find(".zip_dl_modal_open_handle").click
    #   doc_image("棋譜の種類を選択")
    #   find(".zip_dl_run").click
    #   doc_image
    # end

    # it "連打対策" do
    #   visit2 "/swars/search?query=devuser1&raise_duplicate_key_error=1"
    #   assert_text "データ収集中なのであと15秒ぐらいしてからお試しください"
    #   doc_image
    # end

    # xit "仕掛けの局面表示" do
    #   visit2 "/swars/search?query=devuser1&display_key=critical"
    #   assert { find(".radio.is-primary").text === "仕掛け" }
    #   doc_image
    # end
    # 
    # xit "終了の局面表示" do
    #   visit2 "/swars/search?query=devuser1&display_key=last"
    #   assert { find(".radio.is-primary").text === "終局図" }
    #   doc_image
    # end
    # 
    # xit "検索フォームでオートコンプリート作動" do
    #   visit2 "/swars/search"
    #   fill_in "query", with: "補完される文字列"
    #   assert_text "補完される文字列の全体"
    #   doc_image
    # end
    # 
    # xit "modal_id の指定があるときモーダルが出て閉じたとき一覧にも1件表示されている" do
    #   visit2 "/swars/search", modal_id: record.to_param
    #   find(".delete").click
    #   page.refresh
    #   assert_text "1-1"
    #   doc_image
    # end

    it "一応KENTOに飛べる" do
      visit2 "/swars/search", query: "devuser1"
      find(".KentoButton").click
      assert_text "KENTO" # "☗ KENTO\nLOGIN\n歩\nLOADING...\nKENTO にログイン\nログインすることにより、利用規約・プライバシーポリシーを読み、これに同意するものとします。\nGoogle でログイン\nTwitter でログイン\nまたは\nメールアドレスにログインリンクを送信".
      doc_image
    end

    # xit "KENTOに正しく棋譜が渡せている" do
    #   # pending "2020-05-13ログイン必須になったため動作しない"
    # 
    #   visit2 "/swars/search", query: "devuser1"
    #   find(".KentoButton").click
    #   assert_text "KENTO"
    #   assert_text "#34"
    #   doc_image
    # end
  end

  describe "show" do
    it "詳細" do
      visit2 "/swars/battles/#{record.to_param}"
      assert_text "devuser1"
      doc_image
    end

    it "画像" do
      visit2 "/swars/battles/#{record.to_param}.png"
      doc_image
    end

    it "画像 + turn + viewpoint" do
      visit2 "/swars/battles/#{record.to_param}.png", turn: -1, viewpoint: "white"
      doc_image
    end
  end
end
