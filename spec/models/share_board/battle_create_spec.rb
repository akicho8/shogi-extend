require "rails_helper"

RSpec.describe ShareBoard::Room do
  let(:params) {
    {
      "room_key" => "(room_key)",
      "title"    => "共有将棋盤",
      "sfen"     => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d 6g6f 7a6b 8h7g 9c9d 9g9f 6c6d 2h8h 6b6c 7i6h 5a4b 5i4h 3a3b 6h6g 6a5b 4h3h 6c5d 6g5f 7c7d 6i5h 4b3a 3h2h 8a7c 3i3h 8b6b 8h6h 7c8e 7g8f 6d6e 8i7g 8e7g+ 8f7g N*8e 7g8f 6e6f 7f7e 5d6e 7e7d P*7b 5f6e 6b6e S*7f 6e6b 7f8e S*6g N*4e 4a4b 6h6i 6g7h+ N*6d 5b6c 6i6f 2b6f 7d7c+ 7b7c 8e7f 6c6d 7f6g 6f8h+ 6g5f 6d5d P*7i 8h7i P*6e 4c4d 4e5c+ 5d5c 5f6g 6b6e 9f9e 9d9e 6g7h 7i7h 5h5i 7h8g 8f6h P*6g 6h7i N*7f P*6i R*8i 7i9g 8i9i+ 9g5c+ 4b5c G*5h 8g7g 1g1f 6g6h+ 6i6h 7g5e S*5f N*3f 2h1h S*2h 5f5e L*1g 2i1g 2h1i+ 1h1i 9i5i 3g3f G*2h 1i2h 5i9i G*6f 6e8e 6f7f 8e8i+ 5h4h P*5d 5e4f 3a2b S*4b 5c4c B*3a 2b1b 1g2e 2c2d 1f1e 2d2e N*2d 1b2c 2d3b+ 2c2d N*1f 2d1e L*1i 2e2f S*2d 1e2e 2g2f 2e2f 3h2g 2f2e 4i3h 8i1i 2h3g B*2h 3h2h 9i3i",
      "turn"     => 142,
      "win_location_key" => "white",
      "memberships" => [
        { "user_name" => "こみつ",       "location_key" => "black", "judge_key" => "lose", },
        { "user_name" => "ぬん！",       "location_key" => "white", "judge_key" => "win",  },
        { "user_name" => "シュワーバー", "location_key" => "black", "judge_key" => "lose", },
      ],
    }.deep_symbolize_keys
  }

  it "works" do
    creator = ShareBoard::BattleCreate.new(params).call
    assert { creator.battle.id }
    assert { creator.success? }
  end

  it "error" do
    creator = ShareBoard::BattleCreate.new(params.merge(fake_error: true)).call
    assert { creator.call.as_json[:error][:message] == "(fake_error)" }
  end
end
