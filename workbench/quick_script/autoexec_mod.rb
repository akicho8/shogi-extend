require "./setup"
QuickScript::Dev::NullScript.new.as_json.has_key?(:fetch_then_auto_exec_action) # => true
