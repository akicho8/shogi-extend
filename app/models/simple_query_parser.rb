module SimpleQueryParser
  extend self

  # assert { SimpleQueryParser.parse("")            == {} }
  # assert { SimpleQueryParser.parse("a")           == {true => ["a"]} }
  # assert { SimpleQueryParser.parse("-a")          == {false => ["a"]} }
  # assert { SimpleQueryParser.parse(" a  b  c  d") == {true => ["a", "b", "c", "d"]} }
  # assert { SimpleQueryParser.parse(" a -b  c -d") == {true => ["a", "c"], false => ["b", "d"]} }
  # assert { SimpleQueryParser.parse("-a -b -c -d") == {false => ["a", "b", "c", "d"]} }
  # assert { SimpleQueryParser.parse(" a -b, c !d") == {true => ["a", "c"], false => ["b", "d"]} }
  def parse(str)
    parse_array(StringSupport.split(str))
  end

  def parse_array(str)
    Array(str).collect { |e|
      e.match(/(?<not>[!-])?(?<value>.+)/)
    }.compact.group_by { |e|
      !e[:not]
    }.transform_values { |e|
      e.collect { |e| e[:value] }
    }
  end
end
