require "rails_helper"

RSpec.describe DateRange, type: :model do
  it "Chronicの残念な仕様で終端を含んでいる" do
    Chronic.parse("2000-1", guess: false).to_s == "(2000-01-01 00:00:00 +0900..2000-02-01 00:00:00 +0900)"
  end

  it "DateRange経由で使えば終端は含まない" do
    assert { DateRange.parse("2000-1-1").to_s == "2000-01-01 00:00:00 +0900...2000-01-02 00:00:00 +0900" }
    assert { DateRange.parse("2000-1").to_s == "2000-01-01 00:00:00 +0900...2000-02-01 00:00:00 +0900" }
    assert { DateRange.parse("2000").to_s == "2000-01-01 00:00:00 +0900...2001-01-01 00:00:00 +0900" }
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> .F
# >> 
# >> Failures:
# >> 
# >>   1) DateRange DateRange経由で使えば終端は含まない
# >>      Failure/Error: Unable to find - to read failed line
# >>      # -:11:in `block (2 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:22:in `block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:22:in `block (2 levels) in <main>'
# >> 
# >> Top 2 slowest examples (0.15929 seconds, 7.7% of total time):
# >>   DateRange DateRange経由で使えば終端は含まない
# >>     0.12973 seconds -:8
# >>   DateRange Chronicの残念な仕様で終端を含んでいる
# >>     0.02956 seconds -:4
# >> 
# >> Finished in 2.06 seconds (files took 3.88 seconds to load)
# >> 2 examples, 1 failure
# >> 
# >> Failed examples:
# >> 
# >> rspec -:8 # DateRange DateRange経由で使えば終端は含まない
# >> 
