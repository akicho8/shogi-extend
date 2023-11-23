require "rails_helper"

module ShortUrl
  RSpec.describe AlnumHash do
    it "だいたい10から11文字になる" do
      a = 100.times.collect { AlnumHash.call(SecureRandom.hex).size }.uniq.sort
      assert2 { a == [10, 11] }
    end

    it "works" do
      assert2 { AlnumHash.call("x") == "crBbpu5siIn" }
    end
  end
end
