require "rails_helper"

RSpec.describe QuickScript::Swars::BasicStatScript, type: :model do
  it "works" do
    ::Swars::Battle.create!
    QuickScript::Swars::BasicStatScript.new.cache_write
    assert { QuickScript::Swars::BasicStatScript.new.call }
  end
end
