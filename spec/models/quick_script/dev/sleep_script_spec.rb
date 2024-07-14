require "rails_helper"

module QuickScript
  RSpec.describe Dev::SleepScript, type: :model do
    it "works" do
      assert { Dev::SleepScript.new.as_json }
    end
  end
end
