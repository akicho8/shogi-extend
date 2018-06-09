require "rails_helper"

RSpec.describe "対戦", type: :system do
  before do
    visit "/online/battles"

    # 作ったユーザーをプレイヤー一覧に反映するため(これはあとで外せる)
    visit "/online/battles"
  end

  # エラーになる(謎)
  #
  # Capybara::NotSupportedByDriverError:
  #   Capybara::Driver::Base#status_code
  #
  # it "正常" do
  #   expect(page).to have_http_status(:success)
  # end

  it "プロフィール表示" do
    visit "/online/users/#{User.last.id}"
    doc_image("プロフィール")
  end

  it "プロフィール設定" do
    visit "/online/users/#{User.last.id}/edit"
    doc_image("プロフィール設定")
  end

  it "ロビーが見れる" do
    doc_image("ロビー")
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
    doc_image("ルール設定")
    click_on("閉じる")
  end

  it "自動マッチング" do
    click_on("バトル開始")
    expect(page).to have_content "マッチング開始"
    doc_image("マッチング開始")
  end

  it "対局リクエスト" do
    # プレイヤー名クリック
    find(".message_link_to").click
    expect(page).to have_content "対局申し込み"
    doc_image("対局申し込み")

    # 申し込む
    click_on("対局申し込み")

    # 挑戦状が届く
    expect(page).to have_content "さんからの挑戦状"
    doc_image("挑戦状受信")

    # 受諾
    click_on("受ける")

    # すこし待たないとだめっぽい
    sleep(2)

    # 対局画面に移動
    _assert { current_path == polymorphic_path([:resource_ns1, BattleRoom.last]) }
    doc_image("対戦開始")
  end
end
