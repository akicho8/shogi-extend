require "#{__dir__}/setup"
Swars::UserKeyValidator.invalid?("xx")               # => true
Swars::UserKeyValidator.valid?("xxx")                # => true
Swars::UserKeyValidator.invalid?("_xxx")             # => true
Swars::UserKeyValidator.valid?("x" * 32)             # => true
Swars::UserKeyValidator.invalid?("x" * 33)           # => true
Swars::UserKeyValidator.new("_").validate! rescue $! # => #<Swars::InvalidKey: 将棋ウォーズのIDではありません : "_">
Swars::UserKeyValidator.valid?("2024_0203")          # => true
