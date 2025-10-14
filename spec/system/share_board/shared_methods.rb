require "rails_helper"

module SharedMethods
end

Pathname(__dir__).glob("shared_methods/*.rb") { |e| require(e) }

RSpec.configure do |config|
  config.include(AliceBobCarol, type: :system, share_board_spec: true)
  config.include(SharedMethods, type: :system, share_board_spec: true)
  config.before(:example, type: :system, share_board_spec: true) do
    setup_share_board
  end
end
