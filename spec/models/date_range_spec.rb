require "rails_helper"

RSpec.describe DateRange, type: :model do
  it "works" do
    assert { DateRange.parse("2000-01-01").to_s              == "2000-01-01 00:00:00 +0900...2000-01-02 00:00:00 +0900" }
    assert { DateRange.parse("2000-01").to_s                 == "2000-01-01 00:00:00 +0900...2000-02-01 00:00:00 +0900" }
    assert { DateRange.parse("2000").to_s                    == "2000-01-01 00:00:00 +0900...2001-01-01 00:00:00 +0900" }
    assert { DateRange.parse("") rescue $!.class             == ArgumentError                                           }
    assert { DateRange.parse("xx") rescue $!.class           == ArgumentError                                           }

    assert { DateRange.parse("2000-01-01..2000-01-01").to_s  == "2000-01-01 00:00:00 +0900...2000-01-02 00:00:00 +0900" }
    assert { DateRange.parse("2000-01-01...2000-01-02").to_s == "2000-01-01 00:00:00 +0900...2000-01-02 00:00:00 +0900" }
    assert { DateRange.parse("2000..2001").to_s              == "2000-01-01 00:00:00 +0900...2002-01-01 00:00:00 +0900" }
    assert { DateRange.parse("2000...2002").to_s             == "2000-01-01 00:00:00 +0900...2002-01-01 00:00:00 +0900" }
    assert { DateRange.parse("2000...").to_s                 == "2000-01-01 00:00:00 +0900...9999-01-01 00:00:00 +0900" }
    assert { DateRange.parse("...2000").to_s                 == "1000-01-01 00:00:00 +0900...2000-01-01 00:00:00 +0900" }
  end

  it "数字っぽいものだけ見ている" do
    assert { DateRange.parse("２０００年１月").to_s == "2000-01-01 00:00:00 +0900...2000-02-01 00:00:00 +0900" }
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> DateRange
# >>   works (FAILED - 1)
# >>   数字っぽいものだけ見ている
# >> 
# >> Failures:
# >> 
# >>   1) DateRange works
# >>      Failure/Error: Unable to find - to read failed line
# >>      # -:16:in `block (2 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:22:in `block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:22:in `block (2 levels) in <main>'
# >> 
# >> Top 2 slowest examples (0.11972 seconds, 6.0% of total time):
# >>   DateRange works
# >>     0.11845 seconds -:4
# >>   DateRange 数字っぽいものだけ見ている
# >>     0.00127 seconds -:19
# >> 
# >> Finished in 1.98 seconds (files took 6.67 seconds to load)
# >> 2 examples, 1 failure
# >> 
# >> Failed examples:
# >> 
# >> rspec -:4 # DateRange works
# >> 
