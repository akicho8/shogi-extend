require "rails_helper"

module Swars
  RSpec.describe KeyToTime, type: :model, swars_spec: true do
    let(:key) { "xxxxxxxx-yyyyyyyy-20130531_010024" }

    it "works" do
      assert { KeyToTime.new(key).to_time.strftime("%F %T") == "2013-05-31 01:00:24" }
    end
  end
end
