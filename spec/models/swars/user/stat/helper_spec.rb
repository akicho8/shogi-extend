require "rails_helper"

RSpec.describe Swars::User::Stat::Helper, type: :model, swars_spec: true do
  include Swars::User::Stat::Helper

  it "map_range" do
    assert { map_range(5, 4, 6, 10, 20) == 15 }
  end
end
