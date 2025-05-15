require "rails_helper"

RSpec.describe QuickScript::Dev::HeaderLinkScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::HeaderLinkScript.new.as_json[:header_link_items] }
  end
end
