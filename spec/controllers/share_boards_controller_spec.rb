require 'rails_helper'

RSpec.describe ShareBoardsController, type: :controller do
  it "HTMLの要求はNuxt側にリダイレクト" do
    get :show, params: { }
    expect(response).to have_http_status(:redirect)
  end

  describe "基本「58玉」" do
    def test(format)
      get :show, params: { body: "position startpos moves 5i5h", turn:1, title: "(title)", format: format }
      expect(response).to have_http_status(:ok)
    end
    it "works" do
      test("png")
      test("kif")
      test("ki2")
      test("sfen")
      test("csa")
    end
  end

  describe "エラーの場合" do
    def test(format)
      get :show, params: { body: "position startpos moves 5i5e", format: format }
      expect(response).to have_http_status(:ok)
    end
    it do
      test("png")
      test("kif")
    end
  end

  describe "「初手55歩」は歩を持ってないためエラー" do
    def test(format)
      get :show, params: { body: "position startpos moves P*5e", format: format }
    end
    it do
      test("png")
      expect(response).to have_http_status(422)
    end
  end

  it "IDではなく棋譜がキーになっている" do
    2.times { get :show, params: { body: "position startpos moves 7g7f", format: "json" } }
    assert { FreeBattle.count == 1 }
  end

  it "Twitterカードに戦法名が出る" do
    get :show, params: { body: "68銀", format: "json" }
    assert { controller.twitter_card_options[:description] == "☗嬉野流 vs ☖その他" }
  end

  it "Twitterカード用の画像パス" do
    get :show, params: { body: "68銀", image_flip: "true", format: "json" }
    assert { controller.current_image_path == "http://test.host/share-board.png?body=position+startpos+moves+7i6h&image_flip=true" }
  end

  it "image_view_point の値がおかしいときにエラーにしない" do
    get :show, params: { body: "68銀", image_view_point: "xxxx", format: "json" }
    expect(response).to have_http_status(:ok)
  end
end
