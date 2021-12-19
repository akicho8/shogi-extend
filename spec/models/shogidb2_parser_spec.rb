require "rails_helper"

RSpec.describe Shogidb2Parser, type: :model do
  it "works" do
    json_params = {
      :id                => 657162,
      :hash              => "0e0f7f6518bca14e5b784015963d5f38795c86a7",
      :handicap          => "平手",
      :end_at            => "2021-12-18T06:48:00.000Z",
      :created_at        => "2021-12-18T23:00:32.000Z",
      :_id               => 657162,
      :開始日時          => "2021-12-18T05:00:00.000Z",
      :終了日時          => "2021-12-18T06:48:00.000Z",
      :棋戦詳細          => "第15回朝日杯将棋オープン戦二次予選",
      :棋戦              => "朝日杯将棋オープン戦",
      :手合割            => "平手",
      :戦型              => "横歩取り",
      :後手              => "飯島栄治 八段",
      :場所              => "東京都渋谷区「シャトーアメーバ」",
      :先手              => "丸山忠久 九段",
      :youtubes          => [],
      :tournament_detail => "第15回朝日杯将棋オープン戦二次予選",
      :tournament        => "朝日杯将棋オープン戦",
      :time_consumed     => "86▲40△40",
      :time              => "40分",
      :strategy          => "横歩取り",
      :start_at          => "2021-12-18T05:00:00.000Z",
      :result            => "gote_win",
      :provider          => "human",
      :player2           => "飯島栄治 八段",
      :player1           => "丸山忠久 九段",
      :place             => "東京都渋谷区「シャトーアメーバ」",
      :moves => [
        {
          :sfen => "lnsgkgsnl/1r5b1/ppppppppp/9/9/7P1/PPPPPPP1P/1B5R1/LNSGKGSNL w - 2",
          :move => "２六歩(27)",
          :hash => "c057f3d656801725865eff21380df70af7c3dafb",
          :csa => "+2726FU",
          :comments => []},
        {
          :sfen => "lnsgkgsnl/1r5b1/pppppp1pp/6p2/9/7P1/PPPPPPP1P/1B5R1/LNSGKGSNL b - 3",
          :move => "３四歩(33)",
          :hash => "d0cfd0d1784896f1b0ac9fbce9a94a956cc4760b",
          :csa => "-3334FU",
          :comments => []},
        {
          :sfen => "lnsgkgsnl/1r5b1/pppppp1pp/6p2/9/2P4P1/PP1PPPP1P/1B5R1/LNSGKGSNL w - 4",
          :move => "７六歩(77)",
          :hash => "2c6ed18123ee740d18367e55f1f799a9eaed2f0a",
          :csa => "+7776FU",
          :comments => []},
        {
          :sfen => "lnsgkgsnl/1r5b1/p1pppp1pp/1p4p2/9/2P4P1/PP1PPPP1P/1B5R1/LNSGKGSNL b - 5",
          :move => "８四歩(83)",
          :hash => "0522329c3bf71d7fab29e64178848288bb54862e",
          :csa => "-8384FU",
          :comments => [],
        },
        {
          :sfen => nil, :move => "投了", :hash => nil, :csa => "%TORYO", :comments => [],
        },
      ],
    }

    assert { Shogidb2Parser.parse(json_params) == <<~EOT }
      開始日時：2021-12-18T05:00:00.000Z
      終了日時：2021-12-18T06:48:00.000Z
      棋戦詳細：第15回朝日杯将棋オープン戦二次予選
      棋戦：朝日杯将棋オープン戦
      手合割：平手
      戦型：横歩取り
      後手：飯島栄治 八段
      場所：東京都渋谷区「シャトーアメーバ」
      先手：丸山忠久 九段

      ２六歩(27) ３四歩(33) ７六歩(77) ８四歩(83) 投了
    EOT
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> .
# >> 
# >> Top 1 slowest examples (0.13128 seconds, 6.6% of total time):
# >>   Shogidb2Parser works
# >>     0.13128 seconds -:4
# >> 
# >> Finished in 2 seconds (files took 4.09 seconds to load)
# >> 1 example, 0 failures
# >> 
