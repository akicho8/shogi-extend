require "rails_helper"

RSpec.describe type: :system do
  it "works" do
    visit_to "http://localhost:3000/u/(unknown_key)"
    assert_text("ActiveRecord::RecordNotFound")
  end
end
