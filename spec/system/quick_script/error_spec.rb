require "rails_helper"

RSpec.describe "エラー処理", type: :system do
  it "ページが見つかりません" do
    visit2 "/bin/swars/xxx"
    assert_text "ページが見つかりません"
  end

  it "指定のメッセージを出す" do
    primary_error_message = SecureRandom.hex
    visit2 "/bin/chore/status_code", status_code: 404, primary_error_message: primary_error_message
    assert_selector(:element, text: primary_error_message, exact_text: true)
  end

  it "権限がありません" do
    visit2 "/bin/chore/status_code", status_code: 403
    assert_selector(:element, text: "ログインする", exact_text: true)
  end

  it "ぶっこわれました" do
    visit2 "/bin/chore/status_code", status_code: 500
    assert_selector(:element, text: "ブラウザをリロードする", exact_text: true)
  end

  it "メンテ中になったのでトップに移動する" do
    visit2 "/bin/chore/status_code", status_code: 503
    assert_current_path "/", wait: 5 # 3秒後に遷移するため
  end
end
