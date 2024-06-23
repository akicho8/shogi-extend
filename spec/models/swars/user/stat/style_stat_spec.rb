require "rails_helper"

module Swars
  RSpec.describe User::Stat::StyleStat, type: :model, swars_spec: true do
    describe "棋風" do
      def case1(tactic_key)
        black = User.create!
        Battle.create!(tactic_key: tactic_key) do |e|
          e.memberships.build(user: black)
        end
        black.stat.style_stat
      end

      it "works" do
        style_stat = case1("新米長玉")
        assert { style_stat.counts_hash == {:rarity_key_SSR => 1,   :rarity_key_SR => 0,   :rarity_key_R => 0,   :rarity_key_N => 0}   }
        assert { style_stat.ratios_hash == {:rarity_key_SSR => 1.0, :rarity_key_SR => 0.0, :rarity_key_R => 0.0, :rarity_key_N => 0.0} }
        assert { style_stat.denominator == 1 }
        assert { style_stat.majority_ratio == 0.0 }
        assert { style_stat.minority_ratio == 1.0 }
      end

      it "to_chart" do
        assert do
          case1("新米長玉").to_chart == [
            { :name => "王道",   :value => 0 },
            { :name => "準王道", :value => 0 },
            { :name => "準変態", :value => 0 },
            { :name => "変態",   :value => 1 },
          ]
        end
      end
    end
  end
end
