require "./setup"
object = QuickScript::Base.new({}, current_user: Object.new, admin_user: Object.new)
object.current_user             # => #<Object:0x000000010c2957e0>
object.admin_user               # => #<Object:0x000000010c295740>
