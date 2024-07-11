require "./setup"

Rails.application.credentials[:gmail_smtp_username]  # => "shogi.extend"
Rails.application.credentials["gmail_smtp_username"] # => "shogi.extend"
Rails.application.credentials.gmail_smtp_username    # => "shogi.extend"
Rails.application.credentials.gmail_smtp_username!   # => "shogi.extend"
Rails.application.credentials[:foo]  # => nil
Rails.application.credentials["foo"] # => nil
Rails.application.credentials.foo    # => nil
Rails.application.credentials.foo! rescue $! # => #<KeyError: :foo is blank>
Rails.application.credentials.fetch(:gmail_smtp_username)  # => "shogi.extend"
Rails.application.credentials.fetch("gmail_smtp_username") rescue $! # => #<KeyError: key not found: "gmail_smtp_username">
Rails.application.credentials.gmail_smtp_username # => "shogi.extend"
Rails.application.credentials.gmail_smtp_username.class.name # => "String"
Rails.application.credentials.class.name # => "ActiveSupport::EncryptedConfiguration"
Rails.application.credentials.config.class # => Hash

# 気持ち悪い使用は OrderedOptions ゆずり
ActiveSupport::OrderedOptions.new(foo: 1).foo!   # => {:foo=>1}
ActiveSupport::OrderedOptions.new(foo: 1).config # => {:foo=>1}
