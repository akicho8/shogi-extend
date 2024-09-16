require "./setup"
QuickScript::Dev::FormCheckboxButtonScript.new(x: "[]").params[:x] # => []
QuickScript::Dev::FormCheckboxButtonScript.new(x: "[a]").params[:x] # => ["a"]
QuickScript::Dev::FormCheckboxButtonScript.new(x: "[a,b]").params[:x] # => ["a", "b"]
