require "./setup"
user = User.create!(name: "alice")
QuickScript::Account::NameEditScript.new({username: "bob"}, {current_user: user, _method: :post}).call
user.reload
user.name                       # => "bob"
