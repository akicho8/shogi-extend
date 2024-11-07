require "rails_helper"

module Swars
  RSpec.describe User::GeneralScopeMethods, type: :model, swars_spec: true do
    it ".vip_only" do
      assert { User.vip_only.empty? }
    end

    it ".vip_except" do
      User.create!
      assert { User.vip_except.exists? }
    end

    it ".momentum_only" do
      user = User.create!
      user.search_logs.create!
      assert { User.momentum_only(period: 0.days, at_least: 1) == [user] }
    end
  end
end
