require "rails_helper"

module Swars
  RSpec.describe User::Stat::ExperimentalStyleStat, type: :model, swars_spec: true do
    describe "棋風" do
      def case1(tactic_key)
        black = User.create!
        Battle.create!(tactic_key: tactic_key) do |e|
          e.memberships.build(user: black)
        end
        black.stat.experimental_style_stat
      end

      it "works" do
        experimental_style_stat = case1("新米長玉")
        assert { experimental_style_stat.counts_hash == {:rarity_key_SSR => 1} }
        assert { experimental_style_stat.ratios_hash == {:rarity_key_SSR => 1.0, :rarity_key_SR => 0.0, :rarity_key_R => 0.0, :rarity_key_N => 0.0} }
        assert { experimental_style_stat.denominator == 1 }
        assert { experimental_style_stat.majority_ratio == 0.0 }
        assert { experimental_style_stat.minority_ratio == 1.0 }
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
