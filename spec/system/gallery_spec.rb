require "rails_helper"

RSpec.describe "木目テクスチャ集", type: :system do
  it "works" do
    visit2 "/gallery"
    assert_text("木目テクスチャ集")
    first(".pagination-next").click
    first(".pagination-previous").click
  end
end
