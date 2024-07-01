require "./setup"
QuickScript::Swars::PrisonScript.new.call.count # => 3
QuickScript::Swars::PrisonScript.new.call.total_count # => 3410
tp QuickScript::Swars::PrisonScript.ancestors # => [QuickScript::Swars::PrisonScript, QuickScript::SessionMod, QuickScript::PaginationMod, QuickScript::Base, ActiveSupport::Dependencies::RequireDependency, ActiveSupport::ToJsonWithActiveSupportEncoder, Object, PP::ObjectMixin, ActiveSupport::Tryable, JSON::Ext::Generator::GeneratorMethods::Object, DEBUGGER__::TrapInterceptor, Kernel, BasicObject]
# >> |------------------------------------------------|
# >> | QuickScript::Swars::PrisonScript               |
# >> | QuickScript::SessionMod                        |
# >> | QuickScript::PaginationMod                     |
# >> | QuickScript::Base                              |
# >> | ActiveSupport::Dependencies::RequireDependency |
# >> | ActiveSupport::ToJsonWithActiveSupportEncoder  |
# >> | Object                                         |
# >> | PP::ObjectMixin                                |
# >> | ActiveSupport::Tryable                         |
# >> | JSON::Ext::Generator::GeneratorMethods::Object |
# >> | DEBUGGER__::TrapInterceptor                    |
# >> | Kernel                                         |
# >> | BasicObject                                    |
# >> |------------------------------------------------|
