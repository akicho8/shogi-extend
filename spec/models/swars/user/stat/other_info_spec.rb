require "rails_helper"

module Swars
  RSpec.describe User::Stat::OtherInfo, type: :model, swars_spec: true do
    it "works" do
      assert { User::Stat::OtherInfo.values }
    end
  end
end
