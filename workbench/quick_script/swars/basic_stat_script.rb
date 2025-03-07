require "./setup"
# _ { QuickScript::Swars::BasicStatScript.new.call } # => "1171.50 ms"
# s { QuickScript::Swars::BasicStatScript.new.call } # => {["white", "draw"]=>181, ["black", "draw"]=>181, ["white", "lose"]=>30183, ["black", "lose"]=>34913, ["white", "win"]=>34913, ["black", "win"]=>30183}
tp QuickScript::Swars::BasicStatScript.new.call
# >> |--------------------|
# >> | 0.4636690426447094 |
# >> | 0.5363309573552907 |
# >> |--------------------|
