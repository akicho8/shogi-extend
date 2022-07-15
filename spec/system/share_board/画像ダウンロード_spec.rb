require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_app
    hamburger_click
    menu_item_click2("画像ダウンロード")        # 開く
    assert_selector(".ImageDlModal")            # モーダルが開いている

    find(".image_size_key_dropdown").click      # サイズ変更ドロップダウンを開く
    find(".is_image_size_1600x1200").click      # サイズ確定

    find(".ShareBoardColorThemeDropdown").click # 配色変更ドロップダウンを開く
    find(".is_color_theme_real").click          # 配色確定

    find(".download_handle").click              # ダウンロード実行
    find(".close_handle").click                 # 閉じる
  end
end
