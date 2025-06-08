require "./setup"
scope = Swars::Membership.where(id: ::Swars::Membership.last(1000).collect(&:id))
object = QuickScript::Swars::TacticStatScript.new({}, {scope: scope})
object.cache_write
tp object.call[:infinite][:records]
QuickScript::Swars::TacticListScript.new(query: "戦法 アヒ -裏").current_items  # => 
tp QuickScript::Swars::TacticListScript.new.as_general_json
# ~> -:2:in '<main>': uninitialized constant TacticStatScript (NameError)
