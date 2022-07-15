require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "ツイートモーダル" do
    a_block do
      visit_app
      find(".tweet_modal_handle").click   # モーダル起動
      assert_text("この局面をツイート")
      find(".TweetModal .dropdown").click # テーマ選択
      assert_text("紙面風")
    end
  end

  it "ツイート画像の視点設定" do
    a_block do
      visit_app
      hamburger_click
      menu_item_click("ツイート画像の視点設定")                 # 開く
      assert_selector(".AbstractViewpointKeySelectModal")       # モーダルが開いている
      find(".AbstractViewpointKeySelectModal .white").click     # 「常に☖」を選択
      find(".submit_handle").click                              # 「保存」
      assert_no_selector(".AbstractViewpointKeySelectModal")    # モーダルが閉じている
      assert { current_query["abstract_viewpoint"] == "white" } # URLが変更になっている
    end
  end
end
