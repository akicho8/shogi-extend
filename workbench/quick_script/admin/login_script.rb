require "./setup"
_ { QuickScript::Admin::LoginScript.new.call } # => "3.44 ms"
s { QuickScript::Admin::LoginScript.new.call } # => {:admin_user=>nil, :current_user=>nil}
