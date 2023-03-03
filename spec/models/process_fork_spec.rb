require "rails_helper"

RSpec.describe ProcessFork, type: :model do
  it "works" do
    ProcessFork.call {}
  end
end
