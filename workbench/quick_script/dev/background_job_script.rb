require "../setup"
QuickScript::Dev::BackgroundJobScript.new.call # => nil
QuickScript::Dev::BackgroundJobScript.new({ _method: "post" }).call # => {:_autolink=>nil}
QuickScript::Dev::BackgroundJobScript.new({}, running_in_background: true).call # => #<AppLog id: 1865180, level: "important", emoji: "", subject: "バックグラウンド実行完了()", body: "{}", process_id: 99632, created_at: "2024-07-20 14:04:20.000000000 +0900">
