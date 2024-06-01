require "rails_helper"

module Swars
  RSpec.describe UserStat::OtherInfo, type: :model, swars_spec: true do
    it "works" do
      assert { Swars::UserStat::OtherInfo.values }
    end
  end
end
