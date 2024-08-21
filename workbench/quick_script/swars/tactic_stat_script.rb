require "./setup"

tp QuickScript::Swars::TacticStatScript.new({tactic_key: :attack}).table_rows
tp QuickScript::Swars::TacticStatScript.new({tactic_key: :defense}).table_rows
tp QuickScript::Swars::TacticStatScript.new({tactic_key: :technique}).table_rows
tp QuickScript::Swars::TacticStatScript.new({tactic_key: :note}).table_rows
