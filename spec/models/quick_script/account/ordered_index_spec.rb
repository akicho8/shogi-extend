require "rails_helper"

RSpec.describe QuickScript::Account::OrderedIndex, type: :model do
  it "works" do
    assert { QuickScript::Account::OrderedIndex.size == 8 }
  end
end
