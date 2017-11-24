require "rails_helper"

RSpec.describe "ConvertInfos", type: :system do
  before do
    @convert_info = ConvertInfo.create!
  end

  it "トップ" do
    visit "/"
    expect(page).to have_content "Github"
  end

  it "一覧" do
    visit "/x"
    expect(page).to have_content "一覧"
  end

  it "入力→変換→完了" do
    visit "/x/new"

    expect(page).to have_field "convert_info[kifu_body]"
    expect(page).to have_field "convert_info[kifu_url]"
    expect(page).to have_field "convert_info[kifu_file]"

    fill_in "convert_info[kifu_body]", with: "76歩"
    click_button "変換"

    expect(page).to have_content "変換完了"
    expect(page).to have_content "▲７六歩"
  end
end
