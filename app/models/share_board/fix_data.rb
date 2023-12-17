# -*- compile-command: "rails runner ShareBoard::FixData.new.call" -*-

module ShareBoard
  class FixData
    def call
      [
        {
          :id => 188,
          :created_at => "2023-05-05 21:13:55 +0900",
          "room_key"=>"5月銀河戦",
          "title"=>"共有将棋盤",
          "sfen"=>"position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d 2g2f 4c4d 3i4h 3a4b 5i6h 4b4c 2f2e 2b3c 6h7h 8b3b 9g9f 9c9d 8h7g 5a6b 7h8h 6b7b 9i9h 4a5b 8h9i 7b8b 7i8h 3d3e 1g1f 7a7b 4i5h 3c5a 5h6h 1c1d 6h7h 3b3d 4g4f 3e3f 3g3f 3d3f 4h3g 3f3d 4f4e 2a3c 4e4d 4c4d P*3f 4d4e 2h2f 3d7d 3f3e P*4f 3g4f 7d7f 7g6f 4e4f 2f4f P*4e 6f9c+ 8a9c 4f7f B*6e 7f2f 6e4g+ 6i7i 4g2e 2f2h P*3f 9f9e 2c2d 9e9d 9c8e 8g8f P*9g 8i9g 9a9d P*9e 8e9g+ 9h9g P*9f 9g9f 2e4c 9e9d S*9h 9i9h",
          "turn"=>81,
          "win_location_key"=>"white",
          "memberships"=>[
            {"user_name"=>"コンソメ",   "location_key"=>"black", "judge_key"=>"lose"},
            {"user_name"=>"きなこもち", "location_key"=>"white", "judge_key"=>"win"},
            {"user_name"=>"sei",        "location_key"=>"black", "judge_key"=>"lose"},
            {"user_name"=>"かべがみ",   "location_key"=>"white", "judge_key"=>"win"},
            {"user_name"=>"ロカボ",     "location_key"=>"black", "judge_key"=>"lose"},
          ],
        },

        {
          :id => 190,
          :created_at => "2023-05-05 22:01:13 +0900",
          "room_key"   => "5月銀河戦",
          "title"       => "共有将棋盤",
          "sfen"        => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 2h7h 8c8d 7g7f 8d8e 8h7g 7a6b 5i4h 5a4b 1g1f 1c1d 4h3h 4b3b 7i8h 3c3d 3h2h 2b3c 7g3c+ 2a3c 8h7g 3b2a 6i5h 3a2b 3i3h 4a3a 7h8h B*4d 7g6f 6a5a B*5f 5a4b 4g4f 5c5d 5f3d 6c6d 3g3f 6d6e 6f7g 6b6c 5h4g 6c6d 8h6h 7c7d 2i3g 8a7c 9i9h 9c9d 3g4e 9d9e 5g5f 5d5e 5f5e 4d5e P*5d P*5b 6h5h 8e8f 8g8f 9e9f 9g9f 5e7g+ 8i7g 8b8f B*9g 8f7f 9g6d 7f7g+ 5d5c+ 5b5c 4e5c+ 4b5c 6d5c+ S*4b 5c4b 3a4b 5h5a+ B*3a P*5c P*3g 3h3g 7g6h S*3h N*2e S*2f 2e3g+ 4g3g N*2e 3g4g S*5h 4i5h 6h5h G*4h 5h9h 5c5b+ P*3g 2f2e 3g3h+ 2h3h 3c2e 3d2e S*5i P*5h 5i4h+ 4g4h 9h8i 5b4b L*2d G*3b 2a1b 3b2b 3a2b 4b3b 2d2e 5a2a 1b1c 2a2b",
          "turn"        => 115,
          "win_location_key" => "black",
          "memberships" => [
            {"user_name"=>"かべがみ",   "location_key"=>"black", "judge_key"=>"win"},
            {"user_name"=>"コンソメ",   "location_key"=>"white", "judge_key"=>"lose"},
            {"user_name"=>"きなこもち", "location_key"=>"black", "judge_key"=>"win"},
            {"user_name"=>"sei",        "location_key"=>"white", "judge_key"=>"lose"},
          ],
        },
      ].each do |params|
        params = params.deep_symbolize_keys
        room = ShareBoard::Room.find_or_create_by!(key: params[:room_key])
        battle = room.battles.find(params[:id])
        # battle.memberships.destroy_all
        # battle.memberships.create!(params[:memberships])
        battle.memberships.each do |e|
          e.created_at = params[:created_at]
          e.updated_at = params[:created_at]
          e.save!
        end
      end
    end
  end
end
