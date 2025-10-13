require "rails_helper"

RSpec.describe RspecState, type: :model do
  it "works" do
    assert { RspecState.running? }
  end
end
