require "rails_helper"

module Swars
  RSpec.describe UserStat::VsStat, type: :model, swars_spec: true do
    describe "段級" do
      before do
        @user = User.create!
      end

      def case1(white, judge_key)
        Battle.create! do |e|
          e.memberships.build(user: @user, judge_key: judge_key)
          e.memberships.build(grade: Grade.find_by(key: white))
        end
      end

      before do
        case1("初段", "win")
        case1("九段", "win")
        case1("九段", "win")
        case1("九段", "lose")
      end

      it "works" do
        result = [
          {:grade_name=>"九段", :judge_counts=>{:win=>2, :lose=>1}, :appear_ratio=>0.75},
          {:grade_name=>"初段", :judge_counts=>{:win=>1}, :appear_ratio=>0.25},
        ]
        assert { @user.user_stat.vs_stat.to_chart == result }
      end
    end
  end
end
