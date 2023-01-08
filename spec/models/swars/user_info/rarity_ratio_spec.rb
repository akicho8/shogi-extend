require "rails_helper"

module Swars
  RSpec.describe UserInfo::RarityRatio, type: :model, swars_spec: true do
    describe "棋風" do
      def case1(tactic_key)
        black = User.create!
        Battle.create!(tactic_key: tactic_key) do |e|
          e.memberships.build(user: black)
        end
        black.user_info.rarity_ratio
      end

      it "to_chart" do
        assert { case1("棒銀").to_chart == [{:name=>"王道", :value=>2}, {:name=>"準王道", :value=>1}, {:name=>"準変態", :value=>0}, {:name=>"変態", :value=>0}] }
        assert { case1("新米長玉").to_chart == [{:name=>"王道", :value=>0}, {:name=>"準王道", :value=>0}, {:name=>"準変態", :value=>0}, {:name=>"変態", :value=>1}] }
      end

      it "majority?" do
        assert { case1("棒銀").majority? }
      end

      it "minority?" do
        assert { case1("新米長玉").minority? }
      end
    end
  end
end
