require "./setup"
s { QuickScript::Dev::FooBarBazScript.new.call } # => nil
QuickScript::Dev::FooBarBazScript.qs_key # => "dev/foo-bar-baz"
