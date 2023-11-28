require "rails_helper"

describe do
  it "works" do
    assert 1 + 2 == 3
    assert_equal 3, 1 + 2
    assert { 1 + 2 == 3 }
    expect(1 + 2).to eq(3)
  end
end
