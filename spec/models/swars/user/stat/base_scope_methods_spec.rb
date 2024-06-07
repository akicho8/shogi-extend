require "rails_helper"

module Swars
  RSpec.describe User::Stat::BaseScopeMethods, type: :model, swars_spec: true do
    def case1
      @black = User.create!
      Battle.create! do |e|
        e.memberships.build(user: @black)
      end
    end

    it "works" do
      case1
      assert { @black.stat.ids_scope.win_only  }
      assert { @black.stat.ids_scope.lose_only }
      assert { @black.stat.win_ratio           }
    end
  end
end
