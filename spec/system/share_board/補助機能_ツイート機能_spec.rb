require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "モーダル" do
    a_block do
      visit_app
      find(".tweet_modal_handle").click                          # モーダル起動
      assert_selector(:button, text: "モダン", exact_text: true) # 初期値を確認する
      find(".SbTweetModal .dropdown").click                      # テーマ選択
      find(".is_color_theme_paper").click                        # 「紙面風」に変更する
      assert_selector(:button, text: "紙面風", exact_text: true) # 「紙面風」に切り替わった
      window = Capybara.window_opened_by do
        find(:button, text: "この局面をツイート", exact_text: true).click
      end
      switch_to_window(window)
      # assert_text("ツイートを共有するにはログインしてください", wait: 10)
      assert_text("x.com", wait: 10) # headless だと英語になってしまう
    end
  end
end
