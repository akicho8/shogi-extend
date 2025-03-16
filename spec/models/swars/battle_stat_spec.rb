require "rails_helper"

RSpec.describe Swars::Battle, type: :model, swars_spec: true do
  it "works" do
    assert { Swars::Battle.stat }
  end
end
