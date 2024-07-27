require "./setup"
object = QuickScript::Dev::NullScript.new({}, controller: Object.new)
object.controller               # => #<Object:0x000000010d6328c0>
