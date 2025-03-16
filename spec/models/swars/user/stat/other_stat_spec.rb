require "rails_helper"

RSpec.describe Swars::User::Stat::OtherStat, type: :model, swars_spec: true do
  describe "他" do
    def case1
      @black = Swars::User.create!
      Swars::Battle.create! do |e|
        e.memberships.build(user: @black)
      end
    end
    it "works" do
      case1
      assert { @black.stat.other_stat.to_a       }
      assert { @black.stat.other_stat.execution_time_explain }
    end
  end
end
