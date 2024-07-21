require "./setup"
QuickScript::Dev::NullScript.new.as_json.has_key?(:auto_exec_action) # => true
