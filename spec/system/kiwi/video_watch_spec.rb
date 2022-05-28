require "rails_helper"

RSpec.describe "動画詳細", type: :system, kiwi: true do
  include KiwiSupport
  include AliceBobCarol

  before do
    Wkbk.setup

    login
  end

  it "コメント送受信" do
    a_block do
      visit2("/video/watch/1")                            # 動画詳細へ
    end
    b_block do
      visit2("/video/watch/1")                            # 動画詳細へ
    end
    a_block do
      find(".MessageInput textarea").set("(new_message)") # コメント入力
      find(".MessageInput .speak_handle").click           # 送信
      assert_text "(new_message)"                         # コメント受信
    end
    b_block do
      assert_text "(new_message)"                         # コメント受信
    end
  end

  it "将棋盤に切り替え" do
    visit2("/video/watch/1")                            # 動画詳細へ

    find(".KiwiBananaShowMain .switch_handle").click      # 切り替え
    assert_selector ".CustomShogiPlayer"                # 将棋盤 ON
    assert_no_selector "video"                          # 動画   OFF

    find(".KiwiBananaShowMain .switch_handle").click      # 切り替え
    assert_no_selector ".CustomShogiPlayer"             # 将棋盤 ON
    assert_selector "video"                             # 動画   OFF
  end
end
