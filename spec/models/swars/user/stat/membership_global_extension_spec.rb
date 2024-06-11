require "rails_helper"

module Swars
  RSpec.describe User::Stat::MembershipGlobalExtension, type: :model, swars_spec: true do
    def case1(*judge_keys)
      @black = User.create!
      judge_keys.each do |judge_key|
        Battle.create! do |e|
          e.memberships.build(user: @black, judge_key: judge_key)
        end
      end
    end

    it "total_judge_counts" do
      case1(:win, :lose, :win)
      assert { @black.memberships.total_judge_counts == { win: 2, lose: 1 } }
    end
  end
end
