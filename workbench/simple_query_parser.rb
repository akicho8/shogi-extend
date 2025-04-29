require "./setup"
SimpleQueryParser.parse("")            # => {}
SimpleQueryParser.parse("a")           # => {true => ["a"]}
SimpleQueryParser.parse("-a")          # => {false => ["a"]}
SimpleQueryParser.parse(" a  b  c  d") # => {true => ["a", "b", "c", "d"]}
SimpleQueryParser.parse(" a -b  c -d") # => {true => ["a", "c"], false => ["b", "d"]}
SimpleQueryParser.parse("-a -b -c -d") # => {false => ["a", "b", "c", "d"]}
SimpleQueryParser.parse(" a -b, c !d") # => {true => ["a", "c"], false => ["b", "d"]}
