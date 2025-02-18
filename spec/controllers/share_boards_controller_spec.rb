require "rails_helper"

RSpec.describe ShareBoardsController, type: :controller, share_board_spec: true do
  it "HTMLの要求はNuxt側にリダイレクト" do
    get :show, params: { }
    assert { response.status == 302 }
  end

  describe "基本「58玉」" do
    def test(format, status)
      get :show, params: { body: "position startpos moves 5i5h", turn:1, title: "(title)", format: format }
      assert { response.status == status }
    end
    it "works" do
      test("png", 200)
      test("kif", 200)
      test("ki2", 200)
      test("sfen", 200)
      test("csa", 200)
    end
  end

  describe "エラーの場合" do
    def test(format, status)
      get :show, params: { body: "position startpos moves 5i5e", format: format }
      assert { response.status == status }
    end
    it "works" do
      test("png", 200)
      test("kif", 200)
    end
  end

  describe "「初手55歩」は歩を持ってないためエラー" do
    def test(format)
      get :show, params: { body: "position startpos moves P*5e", format: format }
    end
    it "works" do
      test("png")
      assert { response.status == 422 }
    end
  end

  it "IDではなく棋譜がキーになっている" do
    FreeBattle.destroy_all
    2.times { get :show, params: { body: "position startpos moves 7g7f", format: "json" } }
    assert { FreeBattle.count == 1 }
  end

  it "Twitterカードに戦法名が出る" do
    get :show, params: { body: "68銀", format: "json" }
    assert { controller.twitter_card_options[:description] == "☗嬉野流 vs ☖その他" }
  end

  it "Twitterカード用の画像パス" do
    get :show, params: { body: "68銀", viewpoint: "white", format: "json" }
    assert { controller.current_og_image_path == "/share-board.png?body=position+sfen+lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+b+-+1+moves+7i6h&title=%E5%85%B1%E6%9C%89%E5%B0%86%E6%A3%8B%E7%9B%A4&turn=1&viewpoint=white" }
  end

  it "viewpoint の値がおかしいときにエラーにしない" do
    get :show, params: { body: "68銀", viewpoint: "xxxx", format: "json" }
    assert { response.status == 200 }
  end

  it "配色テーマのサムネイル画像" do
    # http://localhost:3000/share-board.png?color_theme_key=is_color_theme_real&color_theme_preview_image_use=true
    get :show, params: { color_theme_preview_image_use: "true", format: "png" }
    assert { response.media_type == "image/png" }
    assert { response["Content-Disposition"].match?(/is_color_theme_modern/) }
    assert { response.status == 200 }
  end

  it "KIF等に変換するときに追加情報をヘッダに入れる" do
    # http://localhost:3000/share-board.kif?black=alice&white=bob&other=carol&title=title&body=position.startpos
    get :show, params: { black: "alice", format: "kif", body: "position startpos" }
    assert { response.body.include?("先手：alice") }
  end
end
