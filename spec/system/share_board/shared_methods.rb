require "rails_helper"
Pathname(__dir__).glob("shared_methods/*.rb") { |e| require(e) }

module SharedMethods
  extend ActiveSupport::Concern

  included do
    include AliceBobCarol
  end
end

RSpec.configure do |config|
  config.include(SharedMethods, type: :system, share_board_spec: true)
end
