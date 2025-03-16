require "rails_helper"

RSpec.describe Swars::SystemValidator, type: :model, swars_spec: true do
  it "works" do
    Swars::SystemValidator.new.call
  end
end
