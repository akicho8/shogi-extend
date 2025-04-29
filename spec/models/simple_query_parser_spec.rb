require "rails_helper"

RSpec.describe SimpleQueryParser, type: :model do
  it "works" do
    assert { SimpleQueryParser.parse("")            == {} }
    assert { SimpleQueryParser.parse("a")           == { true => ["a"] } }
    assert { SimpleQueryParser.parse("-a")          == { false => ["a"] } }
    assert { SimpleQueryParser.parse(" a  b  c  d") == { true => ["a", "b", "c", "d"] } }
    assert { SimpleQueryParser.parse(" a -b  c -d") == { true => ["a", "c"], false => ["b", "d"] } }
    assert { SimpleQueryParser.parse("-a -b -c -d") == { false => ["a", "b", "c", "d"] } }
    assert { SimpleQueryParser.parse(" a -b, c !d") == { true => ["a", "c"], false => ["b", "d"] } }
  end
end
