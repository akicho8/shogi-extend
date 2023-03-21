require "rails_helper"

module Swars
  RSpec.describe DistributionRatio, type: :model, swars_spec: true do
    it "as_json" do
      Battle.create!
      json = DistributionRatio.new.as_json
      item = json[:items].find { |e| e[:name] == "2手目△３ニ飛戦法" }
      is_asserted_by { item }
      is_asserted_by { item[:count]  == 1 }
      is_asserted_by { item[:emission_ratio]  == 0.5 }
      is_asserted_by { item[:rarity_key] == :rarity_key_N }
      is_asserted_by { !json[:items].find { |e| e[:name] == "居玉" } }
      is_asserted_by { json[:meta][:histogram] }
    end
  end
end
