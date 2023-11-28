if defined?(RSpec::PowerAssert)
  # 前までブロック対応の assert に置き換えれたが Rails (RSpec?) を新しくしたらダメになった
  # なので絶対に使える assert2 にした
  #
  # RSpec::PowerAssert.verbose_successful_report = false     # true にすると成功したブロックまで結果が表示される
  # RSpec::PowerAssert.example_assertion_alias :assert       # rspec-rails のせいで assert2 が上書きされてしまうため assert にできない
  # RSpec::PowerAssert.example_group_assertion_alias :assert # 同じ名前でもいいみたい。でも使わない。
  # RSpec::Rails::Assertions.remove_method(:assert)          # 干渉するというかこっちが使われてしまうので消しておく
  # raise
  # RSpec::PowerAssert.example_assertion_alias :assert
end

if defined?(PowerAssert)
  PowerAssert.configure do |config|
    config.lazy_inspection  = true
    config.colorize_message = true
    config.inspector        = :pp
  end
end
