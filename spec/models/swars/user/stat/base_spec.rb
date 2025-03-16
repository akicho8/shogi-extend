require "rails_helper"

RSpec.describe Swars::User::Stat::Base, type: :model, swars_spec: true do
  it "works" do
    user = Swars::User.create!
    assert { Swars::User::Stat::Base.new(user) }
  end
end
