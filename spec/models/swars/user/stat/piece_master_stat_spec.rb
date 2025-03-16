require "rails_helper"

RSpec.describe Swars::User::Stat::PieceMasterStat, type: :model, swars_spec: true do
  def case1(n)
    user = Swars::User.create!
    Swars::Battle.create!(csa_seq: Swars::KifuGenerator.generate_n(n)) do |e|
      e.memberships.build(user: user)
    end
    user.stat.piece_master_stat.average_above?(:"玉")
  end

  it "average_above?" do
    assert { case1(0) == false }
    assert { case1(1) == true  }
  end
end
