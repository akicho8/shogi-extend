require "rails_helper"
Pathname(__dir__).glob("shared_methods/*.rb") { |e| require(e) }

module SharedMethods
  extend ActiveSupport::Concern

  included do
    include AliceBobCarol

    before(:example) do
      p ["#{__FILE__}:#{__LINE__}", __method__, self]
      eval_code %(ShareBoard.setup(force: true))
      sfen_info = SfenInfo["相全駒手番△"]
      eval_code %(ShareBoard::Room.mock(room_key: 'test_room', sfen: "#{sfen_info.sfen}"))
      p ["#{__FILE__}:#{__LINE__}", __method__, ]
    end
  end
end

RSpec.configure do |config|
  config.include(SharedMethods, type: :system, share_board_spec: true)
end
