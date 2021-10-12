require "rails_helper"

RSpec.describe type: :system do
  it "トップ" do
    visit "/"
    assert_text "About"
    doc_image
  end
end
