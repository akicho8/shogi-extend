require "./setup"
# QuickScript::CalcScript.new.call # => 
# QuickScript::CalcScript.deconstruct # => 

name = QuickScript::Chore::CalcScript.name.underscore # => "quick_script/chore/calc_script"
name.remove("quick_script/", "_script")               # => "chore/calc"
