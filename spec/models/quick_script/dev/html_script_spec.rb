require "rails_helper"

RSpec.describe QuickScript::Dev::HtmlScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::HtmlScript.new.as_json }
  end
end
