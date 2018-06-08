if defined?(RSpec::PowerAssert)
  RSpec::PowerAssert.verbose_successful_report = false      # true にすると成功したブロックまで結果が表示される
  RSpec::PowerAssert.example_assertion_alias :_assert       # rspec-rails のせいで assert が上書きされてしまうため assert にできない
  RSpec::PowerAssert.example_group_assertion_alias :_assert # 同じ名前でもいいみたい

  PowerAssert.configure do |config|
    config.lazy_inspection = true # これは何？
    # c._colorize_message = true
    config._use_pp = true
  end
end

# p ["#{__FILE__}:#{__LINE__}", __method__, ]

# p Minitest::PowerAssert::Assertions.instance_methods
# p ::RSpec::Rails::Assertions.instance_methods

# Minitest::Assertions.module_eval { remove_method(:assert) }

# Minitest::Assertions.prepend(Minitest::PowerAssert::Assertions)

# class C < Minitest::Test
#   # include Minitest::Assertions
# end

# p ["#{__FILE__}:#{__LINE__}", __method__, ]
# # Minitest::Test.new.assert {}
# p ["#{__FILE__}:#{__LINE__}", __method__, ]

# p Minitest::Assertions.instance_methods

# ::RSpec::Rails::AssertionDelegator.prepend(Minitest::PowerAssert::Assertions)

# # ::RSpec::Rails::Assertions.include(Minitest::PowerAssert::Assertions)
# p ["#{__FILE__}:#{__LINE__}", __method__, ]

# module Minitest
#   module Assertions
#     prepend  Minitest::PowerAssert::Assertions
#   end
# end
