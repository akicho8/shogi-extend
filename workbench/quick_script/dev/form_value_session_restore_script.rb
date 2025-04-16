require "../setup"
instance = QuickScript::Dev::FormValueSessionRestoreScript.new({ :str1 => "new_value" }, {}).tap(&:as_json)
instance.session # => {"QuickScript::Dev::FormValueSessionRestoreScript"=>{"str1"=>"new_value", "radio1"=>nil}}
