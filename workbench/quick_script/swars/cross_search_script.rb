require "./setup"

QuickScript::Swars::CrossSearchScript.new(x_style_keys: "王道").x_style_infos.collect(&:name) # => ["王道"]
exit

::Swars::Xmode["野良"]          # => 

QuickScript::Swars::CrossSearchScript.new(x_tag: "居飛車", exec: "true", _method: "get").as_json[:redirect_to][:to] # => 
_ { QuickScript::Swars::CrossSearchScript.new(x_tag: "居飛車", exec: "true", _method: "get").all_ids } # => 
_ { QuickScript::Swars::CrossSearchScript.new(x_tag: "居飛車", exec: "true", _method: "get").all_ids } # => 
sql
QuickScript::Swars::CrossSearchScript.new(x_tag: "居飛車", x_judge_keys: "勝ち", exec: "true", _method: "get").all_ids.size # => 


