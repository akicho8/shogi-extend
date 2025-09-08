require "rails_helper"

RSpec.describe Swars::UserKeyValidator, type: :model, swars_spec: true do
  it "works" do
    assert { Swars::UserKeyValidator.invalid?("xx") }
    assert { Swars::UserKeyValidator.valid?("xxx") }
    assert { Swars::UserKeyValidator.invalid?("_xxx") }
    assert { Swars::UserKeyValidator.valid?("x" * 32) }
    assert { Swars::UserKeyValidator.invalid?("x" * 33) }
    assert { (Swars::UserKeyValidator.new("_").validate! rescue $!.class) == Swars::InvalidKey }
  end
end
