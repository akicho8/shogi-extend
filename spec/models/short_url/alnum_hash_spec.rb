require "rails_helper"

RSpec.describe ShortUrl::AlnumHash do
  it "works" do
    assert { ShortUrl::AlnumHash.call("x") == "crBbpu5siIn" }
  end

  it "だいたい9〜11文字になる" do
    a = 100.times.collect { ShortUrl::AlnumHash.call(SecureRandom.hex).size }.uniq.sort
    assert { (9..11).overlap?(Range.new(*a.minmax)) }
  end
end
