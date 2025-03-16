require "rails_helper"

RSpec.describe QuickScript::Dev::FooBarBazScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::FooBarBazScript.new.as_json }
  end
end
