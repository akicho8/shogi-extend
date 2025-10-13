require "rails_helper"

module SharedMethods
  extend ActiveSupport::Concern
end

Pathname(__dir__).glob("shared_methods/*.rb") { |e| require(e) }

RSpec.configure do |config|
  config.include(SharedMethods, type: :system, share_board_spec: true)
end
