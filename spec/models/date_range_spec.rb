require "rails_helper"

RSpec.describe DateRange, type: :model do
  it "works" do
    assert { DateRange.parse("2000-01-01").to_s    == "2000-01-01 00:00:00 +0900...2000-01-02 00:00:00 +0900" }
    assert { DateRange.parse("2000-01").to_s       == "2000-01-01 00:00:00 +0900...2000-02-01 00:00:00 +0900" }
    assert { DateRange.parse("2000").to_s          == "2000-01-01 00:00:00 +0900...2001-01-01 00:00:00 +0900" }
    assert { DateRange.parse("") rescue $!.class   == ArgumentError }
    assert { DateRange.parse("xx") rescue $!.class == ArgumentError }
    assert { DateRange.parse(nil) rescue $!.class  == ArgumentError }
  end

  it "数字っぽいものだけ見ている" do
    assert { DateRange.parse("２０００年１月").to_s == "2000-01-01 00:00:00 +0900...2000-02-01 00:00:00 +0900" }
  end
end
