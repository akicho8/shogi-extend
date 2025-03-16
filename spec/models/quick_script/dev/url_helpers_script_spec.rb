require "rails_helper"

RSpec.describe QuickScript::Dev::UrlHelpersScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::UrlHelpersScript.new.call }
  end
end
