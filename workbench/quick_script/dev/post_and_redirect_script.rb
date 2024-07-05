require "./setup"
QuickScript::Dev::PostAndRedirectScript.new(_method: "post").call # => {:to=>"/bin/dev/null"}
