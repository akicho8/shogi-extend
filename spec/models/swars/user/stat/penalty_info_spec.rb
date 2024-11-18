require "rails_helper"

module Swars
  RSpec.describe User::Stat::PenaltyInfo, type: :model, swars_spec: true do
    it "works" do
      assert { User::Stat::PenaltyInfo.values }
    end
  end
end
