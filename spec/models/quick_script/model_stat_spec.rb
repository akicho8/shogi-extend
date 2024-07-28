require "rails_helper"

module QuickScript
  RSpec.describe ModelStat, type: :model do
    it "works" do
      capture(:stdout) { ModelStat.new.call }
    end
  end
end
