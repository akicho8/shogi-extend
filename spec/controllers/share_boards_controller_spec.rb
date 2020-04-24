require 'rails_helper'

RSpec.describe ShareBoardsController, type: :controller do
  it "最初の表示" do
    get :show, params: { }
    expect(response).to have_http_status(:ok)
  end

  it "先手が指して共有した状態" do
    get :show, params: { body: "position startpos moves 7g7f", turn: 1, title: "(title)" }
    expect(response).to have_http_status(:ok)
  end

  it "そのときの画像" do
    get :show, params: { body: "position startpos moves 7g7f", turn: 1, title: "(title)", format: "png" }
    assert { response.media_type == "image/png" }
  end

  it "IDではなく棋譜がキーになっている" do
    2.times { get :show, params: { body: "position startpos moves 7g7f" } }
    assert { FreeBattle.count == 1 }
  end

  it "ツイートボタンを押したときに一応保存できるか確認している" do
    post :create, params: { body: "position startpos" }
    value = JSON.parse(response.body, symbolize_names: true)
    assert { value[:record] }
  end
end
