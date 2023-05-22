require "rails_helper"

RSpec.describe ErrorInfo do
  it "works" do
    obj = ErrorInfo.new(((1 / 0) rescue $!), data: "(data)", backtrace_lines_max: 2)
    hv = obj.to_h
    assert2 { hv[:emoji] == ":SOS:"                              }
    assert2 { hv[:subject] == "divided by 0 (ZeroDivisionError)" }
    assert2 { hv[:body].include?("(data)")                       }
    # puts "--------"
    # puts hv[:body]
    # puts "--------"
  end
end
