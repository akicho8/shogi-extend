require "./setup"
parameter = QuickScript::Parameter.new(qs_group_key: "dev", qs_page_key: "foo-bar-baz")
parameter.receiver_klass        # => QuickScript::Dev::FooBarBazScript
