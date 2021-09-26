require 'rails_helper'

RSpec.describe ShareBoardsController, type: :controller do
  it "HTMLの要求はNuxt側にリダイレクト" do
    get :show, params: { }
    assert { response.status == 302 }
  end

  # cd ~/src/shogi-extend/ && BROWSER_DEBUG=1 rspec ~/src/shogi-extend/spec/controllers/share_boards_controller_spec.rb -e '基本「58玉」'
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
    it do
      test("png", 200)
      test("kif", 200)
    end
  end

  describe "「初手55歩」は歩を持ってないためエラー" do
    def test(format)
      get :show, params: { body: "position startpos moves P*5e", format: format }
    end
    it do
      test("png")
      assert { response.status == 422 }
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
    get :show, params: { body: "68銀", abstract_viewpoint: "white", format: "json" }
    assert { controller.current_og_image_path == "/share-board.png?abstract_viewpoint=white&body=position+startpos+moves+7i6h&title=%E5%85%B1%E6%9C%89%E5%B0%86%E6%A3%8B%E7%9B%A4&turn=1" }
  end

  it "abstract_viewpoint の値がおかしいときにエラーにしない" do
    get :show, params: { body: "68銀", abstract_viewpoint: "xxxx", format: "json" }
    assert { response.status == 200 }
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ........
# >> 
# >> Finished in 1.44 seconds (files took 2.51 seconds to load)
# >> 8 examples, 0 failures
# >> 
