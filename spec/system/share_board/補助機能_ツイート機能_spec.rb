require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "モーダル" do
    a_block do
      visit_app
      find(".tweet_modal_handle").click   # モーダル起動
      assert_text("この局面をツイート")
      find(".TweetModal .dropdown").click # テーマ選択
      assert_text("紙面風", wait: 60)
    end
  end

  it "画像の視点設定" do
    a_block do
      visit_app
      hamburger_click
      menu_item_click("ツイート画像の視点設定")                 # 開く
      assert_selector(".AbstractViewpointKeySelectModal")       # モーダルが開いている
      find(".AbstractViewpointKeySelectModal .white").click     # 「常に☖」を選択
      find(".submit_handle").click                              # 「保存」
      assert_no_selector(".AbstractViewpointKeySelectModal")    # モーダルが閉じている
      assert { current_query["abstract_viewpoint"].blank? }     # 元々はURLを変更していたが今は変更しないようにした
      assert_system_variable(:abstract_viewpoint, "white")      # 内部では反転しているので問題ない
    end
  end
end
