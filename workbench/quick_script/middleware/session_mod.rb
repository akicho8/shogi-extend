require "./setup"
object = QuickScript::Base.new({}, current_user: Object.new, admin_user: Object.new)
object.current_user             # => #<Object:0x0000000114754c60>
object.admin_user               # => #<Object:0x0000000114754b70>
