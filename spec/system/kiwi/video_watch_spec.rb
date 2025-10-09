require "rails_helper"

RSpec.describe "動画詳細", type: :system, kiwi: true do
  include AliceBobCarol

  before do
    login
  end

  it "コメント送受信" do
    window_a do
      visit_to("/video/watch/1")                            # 動画詳細へ
    end
    window_b do
      visit_to("/video/watch/1")                            # 動画詳細へ
    end
    window_a do
      find(".MessageInput textarea").set("(new_message)") # コメント入力
      find(".MessageInput .speak_handle").click           # 送信
      assert_text "(new_message)"                         # コメント受信
    end
    window_b do
      assert_text "(new_message)"                         # コメント受信
    end
  end

  it "将棋盤に切り替え" do
    visit_to("/video/watch/1")                            # 動画詳細へ
    assert_selector(".KiwiBananaShowMain", wait: 5)     # 遅いPCでは待たないといけない

    find(".KiwiBananaShowMain .switch_handle").click      # 切り替え
    assert_selector ".CustomShogiPlayer"                # 将棋盤 ON
    assert_no_selector "video"                          # 動画   OFF

    find(".KiwiBananaShowMain .switch_handle").click      # 切り替え
    assert_no_selector ".CustomShogiPlayer"             # 将棋盤 ON
    assert_selector "video"                             # 動画   OFF
  end
end
