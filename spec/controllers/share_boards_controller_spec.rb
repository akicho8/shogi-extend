require 'rails_helper'

RSpec.describe ShareBoardsController, type: :controller do
  it "最初の表示" do
    get :show, params: { }
    expect(response).to have_http_status(:ok)
  end

  describe "基本「58玉」" do
    def test(format)
      get :show, params: { body: "position startpos moves 5i5h", turn:1, title: "(title)", format: format }
      expect(response).to have_http_status(:ok)
    end
    it "foo" do
      test("html")
      test("png")
      test("kif")
    end
  end

  describe "基本自由なので「55玉」の棋譜でもエラーにしない" do
    def test(format)
      get :show, params: { body: "position startpos moves 5i5e", format: format }
      expect(response).to have_http_status(:ok)
    end
    it do
      test("html")
      test("png")
      test("kif")
    end
  end

  describe "とはいえ「初手55歩」は歩を持ってないためエラー" do
    def test(format)
      get :show, params: { body: "position startpos moves P*5e", format: format }
    end
    it do
      test("html")
      expect(response).to have_http_status(:redirect)

      test("png")
      expect(response).to have_http_status(422)
    end
  end

  it "IDではなく棋譜がキーになっている" do
    2.times { get :show, params: { body: "position startpos moves 7g7f" } }
    assert { FreeBattle.count == 1 }
  end

  it "Twitterカードに戦法名が出る" do
    get :show, params: { body: "68銀" }
    assert { controller.twitter_card_options[:description] == "☗嬉野流 vs ☖その他" }
  end

  it "Twitterカード用の画像パス" do
    get :show, params: { body: "68銀", image_flip: "true" }
    assert { controller.current_image_path == "http://test.host/share-board.png?body=position+startpos+moves+7i6h&image_flip=true" }
  end

  it "image_view_point の値がおかしいときにエラーにしない" do
    get :show, params: { body: "68銀", image_view_point: "xxxx" }
    expect(response).to have_http_status(:ok)
  end
end
