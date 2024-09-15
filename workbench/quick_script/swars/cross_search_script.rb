require "./setup"

puts QuickScript::Swars::CrossSearchScript.new.empty_message # => nil
exit


QuickScript::Swars::CrossSearchScript.new({exec: "true", download_key: "on"}, {current_user: User.admin}).mail_notify
exit

# tp Swars::Battle.group(:preset).count.keys.collect(&:name)
# QuickScript::Swars::CrossSearchScript.new(x_style_keys: "王道").x_style_infos.collect(&:name) # => ["王道"]
# exit

::Swars::Xmode["野良"]          # => 

QuickScript::Swars::CrossSearchScript.new(x_tag: "居飛車", exec: "true", _method: "get").as_json[:redirect_to][:to] # => 
_ { QuickScript::Swars::CrossSearchScript.new(x_tag: "居飛車", exec: "true", _method: "get").all_ids } # => 
_ { QuickScript::Swars::CrossSearchScript.new(x_tag: "居飛車", exec: "true", _method: "get").all_ids } # => 
sql
QuickScript::Swars::CrossSearchScript.new(x_tag: "居飛車", x_judge_keys: "勝ち", exec: "true", _method: "get").all_ids.size # => 

# >> ひとつも見つかりませんでした。
# >> 「戦法」欄で具体的な戦法や囲いを指定している場合、その時点でほぼスタイルが確定している
