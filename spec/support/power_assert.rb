if defined?(RSpec::PowerAssert)
  # RSpec::PowerAssert.verbose_successful_report = false     # true にすると成功したブロックまで結果が表示される
  # RSpec::PowerAssert.example_assertion_alias :is_asserted_by       # rspec-rails のせいで is_asserted_by が上書きされてしまうため is_asserted_by にできない
  # RSpec::PowerAssert.example_group_assertion_alias :is_asserted_by # 同じ名前でもいいみたい。でも使わない。
  # RSpec::Rails::Assertions.remove_method(:is_asserted_by)          # 干渉するというかこっちが使われてしまうので消しておく

  PowerAssert.configure do |config|
    config.lazy_inspection  = true
    config.colorize_message = true
    config.inspector        = :pp
  end
end
