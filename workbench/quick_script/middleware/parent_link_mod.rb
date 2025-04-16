require "./setup"
object = QuickScript::Dev::NullScript.new({ back_to: "foo" })
object.as_json[:parent_link]                  # => {:force_link_to=>"foo"}
