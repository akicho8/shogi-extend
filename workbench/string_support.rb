require "#{__dir__}/setup"
StringSupport.plus_minus_split("a -b c -d") # => {true => ["a", "c"], false => ["b", "d"]}
StringSupport.plus_minus_split("a")         # => {true => ["a"], false => []}
StringSupport.plus_minus_split("-a")        # => {true => [], false => ["a"]}
StringSupport.plus_minus_split("")          # => {true => [], false => []}
