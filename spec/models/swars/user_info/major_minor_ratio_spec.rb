require "rails_helper"

module Swars
  RSpec.describe UserInfo::MajorMinorRatio, type: :model, swars_spec: true do
    describe "王道戦法度" do
      def case1(tactic_key)
        black = User.create!
        Battle.create!(tactic_key: tactic_key) do |e|
          e.memberships.build(user: black)
        end
        black.user_info.major_minor_ratio
      end

      it "works" do
        assert { case1("棒銀")     == [{:name=>"王道", :value=>3}, {:name=>"マイナー", :value=>0}] }
        assert { case1("新米長玉") == [{:name=>"王道", :value=>0}, {:name=>"マイナー", :value=>1}] }
      end
    end
  end
end
