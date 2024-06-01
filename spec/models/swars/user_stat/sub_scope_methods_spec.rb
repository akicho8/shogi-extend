require "rails_helper"

module Swars
  RSpec.describe UserStat::SubScopeMethods, type: :model, swars_spec: true do
    before do
      @black = User.create!
    end

    def case1
      Battle.create! do |e|
        e.memberships.build(user: @black)
      end
    end

    it "works" do
      case1
      assert { @black.user_stat.ids_scope.win_only   }
      assert { @black.user_stat.ids_scope.lose_only   }
      assert { @black.user_stat.win_ratio }
    end
  end
end
