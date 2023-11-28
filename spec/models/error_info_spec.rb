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
