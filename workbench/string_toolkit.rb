require "#{__dir__}/setup"
StringToolkit.plus_minus_split("a -b c -d") # => {true => ["a", "c"], false => ["b", "d"]}
StringToolkit.plus_minus_split("a")         # => {true => ["a"], false => []}
StringToolkit.plus_minus_split("-a")        # => {true => [], false => ["a"]}
StringToolkit.plus_minus_split("")          # => {true => [], false => []}
