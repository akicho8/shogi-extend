require "./setup"
# QuickScript::Main.script_keys   # => 

# QuickScript::Main.root_dir                # => #<Pathname:/Users/ikeda/src/shogi-extend/app/models/quick_script>
# model_dir = Rails.root.join("app/models") # => #<Pathname:/Users/ikeda/src/shogi-extend/app/models>

Rails.autoloaders.main.eager_load_namespace(QuickScript)
QuickScript::Base.subclasses    # => [QuickScript::Swars::FooScript, QuickScript::Group1::HelloScript, QuickScript::Dev::RouterRedirectScript, QuickScript::Dev::LinkInTableScript, QuickScript::Dev::HrefRedirectScript, QuickScript::Dev::HelloScript, QuickScript::Dev::CalcScript, QuickScript::Chore::IndexScript, QuickScript::Admin::LoginScript]

# QuickScript::Swars::FooScript.meta # => 

tp QuickScript::Main.info
# >> |----------------------------------------+--------------------------+-----------------------------|
# >> | model                                  | title                    | path                        |
# >> |----------------------------------------+--------------------------+-----------------------------|
# >> | QuickScript::Swars::FooScript          | テーブル内リンクのテスト | /script/swars/foo           |
# >> | QuickScript::Group1::HelloScript       | こんにちは表示           | /script/group1/hello        |
# >> | QuickScript::Dev::RouterRedirectScript | 内部リダイレクトのテスト | /script/dev/router_redirect |
# >> | QuickScript::Dev::LinkInTableScript    | テーブル内リンクのテスト | /script/dev/link_in_table   |
# >> | QuickScript::Dev::HrefRedirectScript   | 外部リダイレクトのテスト | /script/dev/href_redirect   |
# >> | QuickScript::Dev::HelloScript          | こんにちは表示           | /script/dev/hello           |
# >> | QuickScript::Dev::CalcScript           | 計算機                   | /script/dev/calc            |
# >> | QuickScript::Chore::IndexScript        | 一覧                     | /script/chore/index         |
# >> | QuickScript::Admin::LoginScript        | ログイン状態の確認       | /script/admin/login         |
# >> |----------------------------------------+--------------------------+-----------------------------|
