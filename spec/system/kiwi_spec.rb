require "rails_helper"

RSpec.describe "動画作成", type: :system do
  it "動画作成" do
    visit "/video/new"
    assert_text "動画作成"
    doc_image
  end

  it "動画ギャラリー" do
    visit "/video"
    assert_text "動画"
    doc_image
  end
end
