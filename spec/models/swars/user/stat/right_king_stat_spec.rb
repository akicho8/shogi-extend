require "rails_helper"

RSpec.describe Swars::User::Stat::RightKingStat, type: :model, swars_spec: true do
  xdescribe "右玉" do
    def case1
      black = Swars::User.create!
      Swars::Battle.create!(strike_plan: "糸谷流右玉") do |e|
        e.memberships.build(user: black)
      end
      black.stat.right_king_stat
    end

    it "右玉度" do
      assert { case1.to_ratio_chart == [{ :name => "右玉", :value => 1 }, { :name => "その他", :value => 0 }] }
    end

    it "右玉ファミリー" do
      assert { case1.to_names_chart == [{ :name => :"糸谷流右玉", :value => 1 }] }
    end
  end
end
