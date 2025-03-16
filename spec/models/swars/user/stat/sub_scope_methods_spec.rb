require "rails_helper"

RSpec.describe Swars::User::Stat::SubScopeMethods, type: :model, swars_spec: true do
  def case1
    Swars::Battle.create! do |e|
      e.memberships.build(user: @black)
    end
  end

  it "works" do
    @black = Swars::User.create!
    case1
    assert { @black.stat.ids_scope.win_only }
    assert { @black.stat.ids_scope.lose_only }
    assert { @black.stat.win_ratio }
  end
end
