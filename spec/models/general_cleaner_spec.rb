require "rails_helper"

RSpec.describe GeneralCleaner, type: :model, swars_spec: true do
  it "works" do
    Swars::Battle.create!
    Swars::Battle.cleaner(execute: true).call
    assert { Swars::Battle.count == 0 }
  end
end
