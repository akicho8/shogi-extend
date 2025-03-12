require "rails_helper"

module QuickScript
  RSpec.describe Swars::BasicStatScript, type: :model do
    it "works" do
      ::Swars::Battle.create!
      Swars::BasicStatScript.new.cache_write
      assert { Swars::BasicStatScript.new.call }
    end
  end
end
