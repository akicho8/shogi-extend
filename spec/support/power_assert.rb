if defined?(RSpec::PowerAssert)
  RSpec::PowerAssert.verbose_successful_report = false           # true にすると成功したブロックまで結果が表示される
  RSpec::PowerAssert.example_assertion_alias :assert             # rspec-rails のせいで assert が上書きされてしまうため assert にできない
  RSpec::PowerAssert.example_group_assertion_alias :assert       # 同じ名前でもいいみたい
  RSpec::Rails::Assertions.send(:remove_method, :assert)         # 干渉するというかこっちが使われてしまうので消しておく

  PowerAssert.configure do |config|
    config.lazy_inspection = true # これは何？
    # c._colorize_message = true
    config._use_pp = true
  end
end
