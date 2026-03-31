require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app
    sidebar_open

    find(".image_download_modal_handle").click                     # 開く
    assert_selector(".ImageDownloadModal")                         # モーダルが開いている

    find(".image_size_key_dropdown").click                         # サイズ変更ドロップダウンを開く
    find(".is_image_size_1080x810").click                          # サイズ確定

    find(".SbColorThemeDropdown").click                            # 配色変更ドロップダウンを開く
    find(".is_color_theme_real").click                             # 配色確定

    find(".download_handle", wait: 5).click                        # ダウンロード実行 (waitは遅いPCのフレーキー対策)
    find(".ImageDownloadModal").assert_text("画像ダウンロード(1)") # 正常にダウンロードが完了したことを確認する

    find(".close_handle").click                                    # 閉じる
  end
end
