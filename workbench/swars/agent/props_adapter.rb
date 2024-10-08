require "./setup"
info = Swars::Agent::Record.new(remote_run: true, key: Swars::BattleKey["raminitk-nakkunnBoy-20240823_213402"]).fetch
pa = Swars::Agent::PropsAdapter.new(info)
tp pa.memberships
tp pa.props
tp pa.to_h
# >> |------------+------------+------------|
# >> | user_key   | grade_info | judge_info |
# >> |------------+------------+------------|
# >> | raminitk   | 初段       | 勝ち       |
# >> | nakkunnBoy | 初段       | 負け       |
# >> |------------+------------+------------|
# >> |--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |               name | raminitk-nakkunnBoy-20240823_213402                                                                                                                                                                                                                                 |
# >> |              gtype |                                                                                                                                                                                                                                                                     |
# >> |      opponent_type | 0                                                                                                                                                                                                                                                                   |
# >> |              sente | raminitk                                                                                                                                                                                                                                                            |
# >> |               gote | nakkunnBoy                                                                                                                                                                                                                                                          |
# >> |          sente_dan | 0                                                                                                                                                                                                                                                                   |
# >> |           gote_dan | 0                                                                                                                                                                                                                                                                   |
# >> |       sente_avatar | _e1812s5c                                                                                                                                                                                                                                                           |
# >> |        gote_avatar | _e2004s2b                                                                                                                                                                                                                                                           |
# >> |             result | SENTE_WIN_DISCONNECT                                                                                                                                                                                                                                                |
# >> |           handicap | 0                                                                                                                                                                                                                                                                   |
# >> | init_sfen_position | lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1                                                                                                                                                                                                     |
# >> |              moves | [{"t"=>598, "n"=>0, "m"=>"+7776FU"}, {"t"=>600, "n"=>1, "m"=>"-3334FU"}, {"t"=>597, "n"=>2, "m"=>"+6766FU"}, {"t"=>590, "n"=>3, "m"=>"-2233KA"}, {"t"=>595, "n"=>4, "m"=>"+7978GI"}, {"t"=>588, "n"=>5, "m"=>"-8222HI"}, {"t"=>593, "n"=>6, "m"=>"+7867GI"}, {"t... |
# >> |--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |-----------+-------------------------------------|
# >> |   対局KEY | raminitk-nakkunnBoy-20240823_213402 |
# >> |  対局日時 | 2024-08-23 21:34:02                 |
# >> |    ルール | 10分                                |
# >> |      種類 | 野良                                |
# >> |    手合割 | 平手                                |
# >> |      結末 | 切断                                |
# >> |  両者名前 | raminitk:初段 vs nakkunnBoy:初段    |
# >> |  勝った側 | ▲                                  |
# >> | 対局後か? | true                                |
# >> | 対局中か? | false                               |
# >> | 正常終了? | true                                |
# >> | 棋譜有り? | true                                |
# >> |  棋譜手数 | 124                                 |
# >> |-----------+-------------------------------------|
