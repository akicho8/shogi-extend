require "./setup"
# QuickScript::Main.script_keys   # => 

# QuickScript::Main.root_dir                # => #<Pathname:/Users/ikeda/src/shogi-extend/app/models/quick_script>
# model_dir = Rails.root.join("app/models") # => #<Pathname:/Users/ikeda/src/shogi-extend/app/models>

Rails.autoloaders.main.eager_load_namespace(QuickScript)
QuickScript::Base.subclasses    # => [QuickScript::Chore::RedirectScript, QuickScript::Chore::LinkScript, QuickScript::Chore::IndexScript, QuickScript::Chore::CalcScript]

tp QuickScript::Base.subclasses.collect { |e| {class: e, title: e.meta[:title], path: e.link_path} }
# >> |------------------------------------+---------+------------------------|
# >> | class                              | title   | path                   |
# >> |------------------------------------+---------+------------------------|
# >> | QuickScript::Chore::RedirectScript | (title) | /script/chore/redirect |
# >> | QuickScript::Chore::LinkScript     | (title) | /script/chore/link     |
# >> | QuickScript::Chore::IndexScript    | (title) | /script/chore/index    |
# >> | QuickScript::Chore::CalcScript     | (title) | /script/chore/calc     |
# >> |------------------------------------+---------+------------------------|
