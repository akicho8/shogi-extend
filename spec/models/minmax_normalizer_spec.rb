require "rails_helper"

RSpec.describe MinmaxNormalizer, type: :model do
  it "works" do
    assert { MinmaxNormalizer.safe_normalize([1, nil, 2]) == [0.0, nil, 1.0] }
    assert { MinmaxNormalizer.safe_normalize([1, 1])      == [nil, nil] }
  end
end
