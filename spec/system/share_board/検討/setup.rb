require "#{__dir__}/../shared_methods"

mod = Module.new do
end

RSpec.configure do |config|
  config.include(mod, type: :system, share_board_spec: true)
end
