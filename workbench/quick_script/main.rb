require "./setup"

# "foo-bar".underscore            # => "foo_bar"
"foo-bar".underscore.dasherize            # => "foo-bar"



# QuickScript::Main.script_keys   # => 

# QuickScript::Main.root_dir                # => #<Pathname:/Users/ikeda/src/shogi-extend/app/models/quick_script>
# model_dir = Rails.root.join("app/models") # => #<Pathname:/Users/ikeda/src/shogi-extend/app/models>

# Rails.autoloaders.main.eager_load_namespace(QuickScript)
# QuickScript::Base.subclasses    # => [QuickScript::Swars::FooScript, QuickScript::Group1::HelloScript, QuickScript::Dev::RouterRedirectScript, QuickScript::Dev::LinkInTableScript, QuickScript::Dev::HrefRedirectScript, QuickScript::Dev::HelloScript, QuickScript::Dev::CalcScript, QuickScript::Chore::IndexScript, QuickScript::Admin::LoginScript]

# QuickScript::Swars::FooScript.meta # => 

tp QuickScript::Main.info
# >> |----------------------------------------+--------------------------+--------------------------|
# >> | model                                  | title                    | path                     |
# >> |----------------------------------------+--------------------------+--------------------------|
# >> | QuickScript::Swars::PrisonScript       | 将棋ウォーズ囚人検索     | /bin/swars/prison        |
# >> | QuickScript::Swars::PrisonAllScript    | 将棋ウォーズ囚人検索     | /bin/swars/prison_all    |
# >> | QuickScript::Group1::HelloScript       | こんにちは表示           | /bin/group1/hello        |
# >> | QuickScript::Dev::TableScript          | テーブル表示             | /bin/dev/table           |
# >> | QuickScript::Dev::RouterRedirectScript | 内部リダイレクトのテスト | /bin/dev/router_redirect |
# >> | QuickScript::Dev::HrefRedirectScript   | 外部リダイレクトのテスト | /bin/dev/href_redirect   |
# >> | QuickScript::Dev::HelloScript          | こんにちは表示           | /bin/dev/hello           |
# >> | QuickScript::Dev::CalcScript           | 計算機                   | /bin/dev/calc            |
# >> | QuickScript::Dev::BodyScript           | 本文表示                 | /bin/dev/body            |
# >> | QuickScript::Chore::IndexScript        | Index                    | /bin/chore/index         |
# >> | QuickScript::Chore::GroupListScript    | 簡易ツール               | /bin/chore/group_list    |
# >> | QuickScript::Admin::LoginScript        | ログイン状態の確認       | /bin/admin/login         |
# >> |----------------------------------------+--------------------------+--------------------------|
