require "rails_helper"

RSpec.describe "対戦", type: :system do
  before do
    visit "/online/battles"
  end

  it "ロビーが見れる" do
    expect(page).to have_content "Rails"
  end

  it "チャットでメッセージ送信" do
    fill_in "chat_message_input", with: "(発言内容)"
    click_on("送信")
    expect(page).to have_content "(発言内容)"
  end

  it "ルール設定" do
    click_on("ルール設定")
    expect(page).to have_content "持ち時間"
    expect(page).to have_content "手合割"
    expect(page).to have_content "人数"
    click_on("閉じる")
  end

  it "バトル開始" do
    click_on("バトル開始")
    expect(page).to have_content "マッチング開始"
  end
end
