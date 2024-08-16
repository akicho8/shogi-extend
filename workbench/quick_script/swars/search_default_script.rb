require "../setup"
QuickScript::Swars::SearchDefaultScript.new({swars_search_default_key: "alice"}, {_method: "post"}).as_json[:flash][:notice] # => "記憶しました"
QuickScript::Swars::SearchDefaultScript.new({swars_search_default_key: ""}, {_method: "post"}).as_json[:flash][:notice]      # => "忘れました"
