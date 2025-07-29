require "./setup"

# tp PermanentVariable

PermanentVariable.destroy_all
PermanentVariable["A"]              # => nil
PermanentVariable["A"] = "x"        # => "x"
PermanentVariable["A"]              # => "x"
PermanentVariable["A"] = { "x" => 1 } # => {"x" => 1}
PermanentVariable["A"]              # => {x: 1}
PermanentVariable["A"] = ""
PermanentVariable["A"]          # => ""

PermanentVariable["A"] = nil
PermanentVariable["A"]          # => nil
