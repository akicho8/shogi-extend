require "rails_helper"

RSpec.describe Shogidb2Parser, type: :model do
  it "works" do
    json_params = {
      :id                => 657766,
      :hash              => "e45b66b8d4e1ba365d4b27f390ccd3661b69b3e0",
      :handicap          => "平手",
      :end_at            => "2021-12-21T21:07:04.000Z",
      :created_at        => "2021-12-21T22:00:25.000Z",
      :_id               => 657766,
      :開始日時          => "2021-12-21T21:00:02.000Z",
      :終了日時          => "2021-12-21T21:07:04.000Z",
      :棋戦詳細          => "wdoor+floodgate-300-10F",
      :棋戦              => "wdoor+floodgate-300-10F",
      :手合割            => "平手",
      :戦型              => nil,
      :後手              => "Shin_LesserKai_1_0_0",
      :場所              => nil,
      :先手              => "Yss1000k",
      :youtubes          => [],
      :tournament_detail => "wdoor+floodgate-300-10F",
      :tournament        => "wdoor+floodgate-300-10F",
      :time_consumed     => nil,
      :time              => nil,
      :strategy          => nil,
      :start_at          => "2021-12-21T21:00:02.000Z",
      :result            => "sente_win",
      :provider          => "floodgate",
      :player2           => "Shin_LesserKai_1_0_0",
      :player1           => "Yss1000k",
      :place             => nil,
      :moves => [
        {
          :sfen => "lnsgkgsnl/1r5b1/ppppppppp/9/9/2P6/PP1PPPPPP/1B5R1/LNSGKGSNL w - 2",
          :move => "７六歩(77)",
          :hash => "66ae3cd31cc88f1188f07f55c0ebd52ed3d08825",
          :csa => "+7776FU",
          :comments => [],
        },
        {
          :sfen => "lnsgkgsnl/1r5b1/p1ppppppp/1p7/9/2P6/PP1PPPPPP/1B5R1/LNSGKGSNL b - 3",
          :move => "８四歩(83)",
          :hash => "0782e63ef287ea779cbd416f25b12bbec98beca0",
          :csa => "-8384FU",
          :comments => [],
        },
        {
          :sfen => "lnsgkgsnl/1r5b1/p1ppppppp/1p7/9/2P6/PP1PPPPPP/1BG4R1/LNS1KGSNL w - 4",
          :move => "７八金(69)",
          :hash => "26f97fc0f6c0e7fe45fb9b7fba888caabd7ae39e",
          :csa => "+6978KI",
          :comments => [],
        },
        {
          :sfen => "lnsgk1snl/1r4gb1/p1ppppppp/1p7/9/2P6/PP1PPPPPP/1BG4R1/LNS1KGSNL b - 5",
          :move => "３二金(41)",
          :hash => "654ceb37c1faaa57ebe1fb09a727fa5a25864853",
          :csa => "-4132KI",
          :comments => [],
        },
        {
          :sfen => "lnsgk1snl/1r4gb1/p1ppppppp/1p7/9/2P4P1/PP1PPPP1P/1BG4R1/LNS1KGSNL w - 6",
          :move => "２六歩(27)",
          :hash => "ecfbdf515cb28b9893410677cc9c849950199069",
          :csa => "+2726FU",
          :comments => [],
        },
        {
          :sfen => "lnsgk1snl/1r4gb1/p1ppppppp/9/1p7/2P4P1/PP1PPPP1P/1BG4R1/LNS1KGSNL b - 7",
          :move => "８五歩(84)",
          :hash => "644d720a1e371192a121d21f3498f6b373f33fc8",
          :csa => "-8485FU",
          :comments => [],
        },
        {
          :sfen => "lnsgk1snl/1r4gb1/p1ppppppp/9/1p7/2P4P1/PPBPPPP1P/2G4R1/LNS1KGSNL w - 8",
          :move => "７七角(88)",
          :hash => "ab5f06520ef71d9a740d40cde8173c013b8549e6",
          :csa => "+8877KA",
          :comments => [],
        },
        {
          :sfen => "lnsgk1snl/1r4gb1/p1pppp1pp/6p2/1p7/2P4P1/PPBPPPP1P/2G4R1/LNS1KGSNL b - 9",
          :move => "３四歩(33)",
          :hash => "b3cc4e4f123f53fc320db22458ec306f12ca9298",
          :csa => "-3334FU",
          :comments => [],
        },
        {
          :sfen => "lnsgk1snl/1r4gb1/p1pppp1pp/6p2/1p7/2P4P1/PPBPPPP1P/1SG4R1/LN2KGSNL w - 10",
          :move => "８八銀(79)",
          :hash => "278bbd01cf70241da8685b478fa9ae5c86ad313c",
          :csa => "+7988GI",
          :comments => [],
        },
        {
          :sfen => "lnsgk1snl/1r4g2/p1pppp1pp/6p2/1p7/2P4P1/PP+bPPPP1P/1SG4R1/LN2KGSNL b 1b 11",
          :move => "７七馬(22)",
          :hash => "95c3a36a3c59512f8701dfc800ea433e6b0ed9a2",
          :csa => "-2277UM",
          :comments => [],
        },
        {
          :sfen => nil,
          :move => "投了",
          :hash => nil,
          :csa => "%TORYO",
          :comments => [],
        },
      ],
    }

    is_asserted_by { Shogidb2Parser.parse(json_params).squish == <<~EOT.squish }
      V2.2
      N+Yss1000k
      N-Shin_LesserKai_1_0_0
      $EVENT:wdoor+floodgate-300-10F
      $START_TIME:2021/12/21 21:00:02
      $END_TIME:2021/12/21 21:07:04
      P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
      P2 * -HI *  *  *  *  * -KA *
      P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
      P4 *  *  *  *  *  *  *  *  *
      P5 *  *  *  *  *  *  *  *  *
      P6 *  *  *  *  *  *  *  *  *
      P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
      P8 * +KA *  *  *  *  * +HI *
      P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
      +
      +7776FU,-8384FU,+6978KI,-4132KI,+2726FU,-8485FU,+8877KA,-3334FU,+7988GI,-2277UM
      %TORYO
    EOT
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Shogidb2Parser
# >>   works
# >> 
# >> Top 1 slowest examples (0.21737 seconds, 10.4% of total time):
# >>   Shogidb2Parser works
# >>     0.21737 seconds -:4
# >> 
# >> Finished in 2.08 seconds (files took 3.54 seconds to load)
# >> 1 example, 0 failures
# >> 
