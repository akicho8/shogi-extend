require "rails_helper"

module Swars
  RSpec.describe DistributionRatio, type: :model, swars_spec: true do
    it "as_json" do
      Battle.create!
      json = DistributionRatio.new.as_json
      expected = {
        :name           => "2手目△３ニ飛戦法",
        :count          => 1,
        :emission_ratio => 0.5,
        :diff_from_avg  => 0.4929328621908127,
        :rarity_key     => :normal,
      }
      assert { json[:items].first == expected }
    end
  end
end
