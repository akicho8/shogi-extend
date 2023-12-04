require "rails_helper"

module ShortUrl
  RSpec.describe AlnumHash do
    it "works" do
      assert { AlnumHash.call("x") == "crBbpu5siIn" }
    end

    it "だいたい9〜11文字になる" do
      a = 100.times.collect { AlnumHash.call(SecureRandom.hex).size }.uniq.sort
      assert { (9..11).overlap?(Range.new(*a.minmax)) }
    end
  end
end
