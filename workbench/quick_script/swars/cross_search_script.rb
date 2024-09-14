require "./setup"

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

# >> 2024-09-14T13:15:02.259Z pid=67642 tid=1koa INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
