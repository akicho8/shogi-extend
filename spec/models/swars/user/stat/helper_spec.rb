require "rails_helper"

module Swars
  RSpec.describe User::Stat::Helper, type: :model, swars_spec: true do
    include User::Stat::Helper

    it "map_range" do
      assert { map_range(5, 4, 6, 10, 20) == 15 }
    end
  end
end
