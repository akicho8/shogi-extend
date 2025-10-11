require "rails_helper"
Pathname(__dir__).glob("shared_methods/*.rb") { |e| require(e) }

module SharedMethods
  extend ActiveSupport::Concern

  included do
    include AliceBobCarol

    before(:example) do
      eval_code %(ShareBoard.setup(force: true))
      sfen = "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 1g1f 1c1d 1f1e 1d1e 1i1e 1a1e P*1d 1e1g+ 1d1c+ 1g2g 1c2c 2g3g 2c3c 3g4g 3c4c 4g5g 4c5c 5g6g 5c6c 6g7g 6c7c 7g8g 7c8c 8g9g 8c9c 9g8h 9c8b 8h9i 8b9a 9i8i 9a8a 8i7i 8a7a 7i7h 7a6a 5a4b 5i4h 7h6i 6a5a 6i5i 5a4a 4b5b 4h5g 5i4i 4a3a 4i3i 3a2a 3i2i 2a2b 2i2h 2b3b 2h3h 3b4b 5b4b 5g4g 3h3i 4g3g 3i4i 3g3f 4b4c 3f3g 4i4h 3g4h 4c3b 4h3h 3b2a 3h2h 2a1a 2h1i"
      eval_code %(ShareBoard::Room.mock(room_key: 'test_room', battle_attribues: {sfen: "#{sfen}"}))
      p ["#{__FILE__}:#{__LINE__}", __method__, ]
    end
  end
end

RSpec.configure do |config|
  config.include(SharedMethods, type: :system, share_board_spec: true)
end
