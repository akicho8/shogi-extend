require "rails_helper"

RSpec.describe Swars::UserKeyValidator, type: :model, swars_spec: true do
  it "works" do
    assert { Swars::UserKeyValidator.invalid?("xx") }
    assert { Swars::UserKeyValidator.valid?("xxx") }
    assert { Swars::UserKeyValidator.invalid?("_xxx") }
    assert { Swars::UserKeyValidator.valid?("x" * 15) }
    assert { Swars::UserKeyValidator.invalid?("x" * 16) }
    expect { Swars::UserKeyValidator.new("_").validate! }.to raise_error(Swars::UserKeyValidator::InvalidKey)
  end
end
