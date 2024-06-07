require "rails_helper"

module Swars
  RSpec.describe User::Stat::Base, type: :model, swars_spec: true do
    it "works" do
      user = User.create!
      assert { User::Stat::Base.new(user) }
    end
  end
end
