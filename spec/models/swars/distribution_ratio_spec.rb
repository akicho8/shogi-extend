require "rails_helper"

module Swars
  RSpec.describe DistributionRatio, type: :model, swars_spec: true do
    it "as_json" do
      Battle.create!
      json = DistributionRatio.new.as_json
      item = json[:items].find { |e| e[:name] == "2手目△３ニ飛戦法" }
      assert { item }
      assert { item[:count]  == 1 }
      assert { item[:emission_ratio]  == 0.5 }
      assert { item[:rarity_key] == :rarity_key_N }
      assert { !json[:items].find { |e| e[:name] == "居玉" } }
      assert { json[:meta][:histogram] }
    end
  end
end
