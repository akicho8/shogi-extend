require "rails_helper"

module Swars
  RSpec.describe UserStat::Base, type: :model, swars_spec: true do
    it "works" do
      user = User.create!
      assert { UserStat::Base.new(user) }
    end
  end
end
