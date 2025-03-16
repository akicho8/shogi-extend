require "rails_helper"

RSpec.describe Swars::User::GeneralScopeMethods, type: :model, swars_spec: true do
  it ".vip_only" do
    assert { Swars::User.vip_only.empty? }
  end

  it ".vip_except" do
    Swars::User.create!
    assert { Swars::User.vip_except.exists? }
  end

  it ".momentum_only" do
    user = Swars::User.create!
    user.search_logs.create!
    assert { Swars::User.momentum_only(period: 0.days, at_least: 1) == [user] }
  end
end
