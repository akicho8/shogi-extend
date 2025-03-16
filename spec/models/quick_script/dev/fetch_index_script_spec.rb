require "rails_helper"

RSpec.describe QuickScript::Dev::FetchIndexScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::FetchIndexScript.new.as_json }
  end
end
