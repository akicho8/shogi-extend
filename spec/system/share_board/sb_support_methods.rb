require "rails_helper"

module SbSupportMethods
end

Pathname(__dir__).glob("sb_support_methods/*.rb") { |e| require(e) }

RSpec.configure do |config|
  config.include(AliceBobCarol, type: :system, share_board_spec: true)
  config.include(SbSupportMethods, type: :system, share_board_spec: true)
  # config.before(:example, type: :system, share_board_spec: true) do
  #   setup_share_board
  # end
end
