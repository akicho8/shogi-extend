require 'rails_helper'

RSpec.describe ShareBoardsController, type: :controller do
  it "最初の表示" do
    get :show, params: { }
    expect(response).to have_http_status(:ok)
  end

  describe "基本" do
    def test(format)
      get :show, params: { body: "position startpos moves 5i5e", turn:1, title: "(title)", format: format }
      expect(response).to have_http_status(:ok)
    end
    it do
      test("html")
      test("png")
    end
  end

  describe "基本自由なので「初手55玉」の棋譜でもエラーにしない" do
    def test(format)
      get :show, params: { body: "position startpos moves 5i5e", format: format }
      expect(response).to have_http_status(:ok)
    end
    it do
      test("html")
      test("png")
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

  # これはもともと最終手が合法手か確認するための機能だったが基本自由なので意味がなくなった
  it "ツイートボタンを押したときに最新の棋譜を取得している" do
    post :create, params: { body: "position startpos" }
    value = JSON.parse(response.body, symbolize_names: true)
    assert { value[:record] }
  end
end
