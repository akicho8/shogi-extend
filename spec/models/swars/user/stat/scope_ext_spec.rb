require "rails_helper"

RSpec.describe Swars::User::Stat::ScopeExt, type: :model, swars_spec: true do
  def case1
    @black = Swars::User.create!
    Swars::Battle.create! do |e|
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
