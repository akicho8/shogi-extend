require "rails_helper"

RSpec.describe ErrorInfo do
  it "works" do
    obj = ErrorInfo.new(((1 / 0) rescue $!), data: "(data)", backtrace_lines_max: 2)
    hv = obj.to_h
    assert { hv[:emoji] == ":SOS:"               }
    assert { hv[:subject] == "ZeroDivisionError" }
    assert { hv[:body].include?("(data)")        }
    # puts "--------"
    # puts hv[:body]
    # puts "--------"
  end
end
# >> Run options: exclude {ai_active: true, login_spec: true, slow_spec: true}
# >>
# >> ErrorInfo
# >>   works
# >>
# >> Top 1 slowest examples (0.12096 seconds, 4.7% of total time):
# >>   ErrorInfo works
# >>     0.12096 seconds -:4
# >>
# >> Finished in 2.57 seconds (files took 2.52 seconds to load)
# >> 1 example, 0 failures
# >>
