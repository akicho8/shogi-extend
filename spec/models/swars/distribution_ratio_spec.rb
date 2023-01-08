require "rails_helper"

module Swars
  RSpec.describe DistributionRatio, type: :model, swars_spec: true do
    it "as_json" do
      Battle.create!
      json = DistributionRatio.new.as_json
      expected = {
        :name           => "2手目△３ニ飛戦法",
        :index          => 0,
        :count          => 1,
        :emission_ratio => 0.5,
        :diff_from_avg  => 0.49644128113879005,
        :rarity_key     => :rarity_key_N,
      }
      assert { json[:items].find { |e| e[:name] == "2手目△３ニ飛戦法" } == expected }
      assert { !json[:items].find { |e| e[:name] == "居玉" } }
      assert { json[:meta][:histogram] }
    end
  end
end
