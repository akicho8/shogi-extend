require "rails_helper"

RSpec.describe ShogiQuestToStandardCsa, type: :model do
  it "works" do
    moves = [{ "m" => "7776FU", "t" => 383 }, { "m" => "3334FU", "t" => 1492 }, { "s" => "LOSE:RESIGN", "t" => 4274 }]
    object = ShogiQuestToStandardCsa.new(moves: moves, created: Time.current, user_names: [:a, :b])
    csa = object.call
    assert { csa == <<~EOT }
V2.2
N+a
N-b
$EVENT:将棋クエスト
$START_TIME:2000/01/01 00:00:00
+
+7776FU,T0
-3334FU,T0
%TORYO
EOT
  end
end
# >> Run options: exclude {ai_active: true, login_spec: true, slow_spec: true}
# >>
# >> ShogiQuestToStandardCsa
# >>   works
# >>
# >> Top 1 slowest examples (0.17042 seconds, 6.0% of total time):
# >>   ShogiQuestToStandardCsa works
# >>     0.17042 seconds -:4
# >>
# >> Finished in 2.83 seconds (files took 3.76 seconds to load)
# >> 1 example, 0 failures
# >>
