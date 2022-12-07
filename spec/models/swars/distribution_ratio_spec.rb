require "rails_helper"

module Swars
  RSpec.describe DistributionRatio, type: :model, swars_spec: true do
    it "as_json" do
      Battle.create!
      items = DistributionRatio.new.as_json
      expected = {
        :name            => "2手目△３ニ飛戦法",
        :count           => 1,
        :rarity          => 0.5,
        :rarity_diff     => 0.49646643109540634,
        :rarity_human    => 50.0,
      }
      assert { items.first == expected }
    end
  end
end
