require "#{__dir__}/../shared_methods"

mod = Module.new do
  def assert_resend_failed_count(count)
    assert_var(:resend_failed_count, count, wait: 30)
  end
end

RSpec.configure do |config|
  config.include(mod, type: :system, share_board_spec: true)
end
