require "./setup"
key = Swars::BattleKey["raminitk-nakkunnBoy-20240823_213402"]
key = Swars::BattleKey["shogi_GPT-yukky1119-20250226_161410"]
key = Swars::BattleKey["shogi_GPT-yukky1119-20250226_161410"]
info = Swars::Agent::Record.new(remote_run: true, key: key).fetch
pp info
pa = Swars::Agent::PropsAdapter.new(info)
tp pa.memberships
tp pa.props
tp pa.to_h
# >> {"gameHash"=>
# >>   {"name"=>"shogi_GPT-yukky1119-20250226_161410",
# >>    "gtype"=>"sb",
# >>    "opponent_type"=>0,
# >>    "init_pos_type"=>1,
# >>    "sente"=>"shogi_GPT",
# >>    "gote"=>"yukky1119",
# >>    "sente_dan"=>-28,
# >>    "gote_dan"=>-29,
# >>    "sente_avatar"=>"_",
# >>    "gote_avatar"=>"_e2004s2b",
# >>    "result"=>"GOTE_WIN_TORYO",
# >>    "handicap"=>0,
# >>    "init_sfen_position"=>
# >>     "4+L2nl/4+R2g1/p1+bp3g1/2p1p1ppp/5pk2/2P5P/PPNPP1S2/2G1G4/L2KS2+rL b S4p2nsb 1",
# >>    "moves"=>
# >>     [{"t"=>140, "n"=>0, "m"=>"+0026GI"},
# >>      {"t"=>177, "n"=>1, "m"=>"-3544OU"},
# >>      {"t"=>132, "n"=>2, "m"=>"+7765KE"},
# >>      {"t"=>147, "n"=>3, "m"=>"-7395UM"},
# >>      {"t"=>121, "n"=>4, "m"=>"+5253RY"},
# >>      {"t"=>144, "n"=>5, "m"=>"-4455OU"},
# >>      {"t"=>98, "n"=>6, "m"=>"+5363RY"},
# >>      {"t"=>131, "n"=>7, "m"=>"-0047KE"},
# >>      {"t"=>92, "n"=>8, "m"=>"+3748GI"},
# >>      {"t"=>88, "n"=>9, "m"=>"-4759NK"},
# >>      {"t"=>90, "n"=>10, "m"=>"+4859GI"},
# >>      {"t"=>85, "n"=>11, "m"=>"-0047KE"},
# >>      {"t"=>83, "n"=>12, "m"=>"+5756FU"},
# >>      {"t"=>73, "n"=>13, "m"=>"-5546OU"},
# >>      {"t"=>67, "n"=>14, "m"=>"+0077KE"},
# >>      {"t"=>61, "n"=>15, "m"=>"-4759NK"},
# >>      {"t"=>66, "n"=>16, "m"=>"+5859KI"},
# >>      {"t"=>48, "n"=>17, "m"=>"-0047KA"},
# >>      {"t"=>64, "n"=>18, "m"=>"+0058KE"},
# >>      {"t"=>40, "n"=>19, "m"=>"-4758UM"},
# >>      {"t"=>63, "n"=>20, "m"=>"+6958OU"},
# >>      {"t"=>36, "n"=>21, "m"=>"-0057GI"},
# >>      {"t"=>59, "n"=>22, "m"=>"+5869OU"},
# >>      {"t"=>33, "n"=>23, "m"=>"-2959RY"}]},
# >>  "userConfig"=>
# >>   {"imgPieceType"=>"ja_single",
# >>    "soundEnable"=>true,
# >>    "voiceType"=>0,
# >>    "situationFormat"=>"evaluation"},
# >>  "isNeedRealtime"=>false,
# >>  "isNeedTargetParent"=>false,
# >>  "isNotReload"=>false,
# >>  "settings"=>
# >>   {"cdn.image"=>"//image-pona.heroz.jp",
# >>    "cdn.sound"=>"//sound-pona.heroz.jp",
# >>    "goldengate.match.host"=>"wss://shogiwars-game-web.heroz.jp:7012",
# >>    "javascript.log_level"=>"error"},
# >>  "version"=>"",
# >>  "askWatchGamesOptions"=>{"isBotOnly"=>false, "closedEventid"=>nil}}
# >> |-----------+------------+------------|
# >> | user_key  | grade_info | judge_info |
# >> |-----------+------------+------------|
# >> | shogi_GPT | 28級       | 負け       |
# >> | yukky1119 | 29級       | 勝ち       |
# >> |-----------+------------+------------|
# >> |--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |               name | shogi_GPT-yukky1119-20250226_161410                                                                                                                                                                                                                                 |
# >> |              gtype | sb                                                                                                                                                                                                                                                                  |
# >> |      opponent_type | 0                                                                                                                                                                                                                                                                   |
# >> |      init_pos_type | 1                                                                                                                                                                                                                                                                   |
# >> |              sente | shogi_GPT                                                                                                                                                                                                                                                           |
# >> |               gote | yukky1119                                                                                                                                                                                                                                                           |
# >> |          sente_dan | -28                                                                                                                                                                                                                                                                 |
# >> |           gote_dan | -29                                                                                                                                                                                                                                                                 |
# >> |       sente_avatar | _                                                                                                                                                                                                                                                                   |
# >> |        gote_avatar | _e2004s2b                                                                                                                                                                                                                                                           |
# >> |             result | GOTE_WIN_TORYO                                                                                                                                                                                                                                                      |
# >> |           handicap | 0                                                                                                                                                                                                                                                                   |
# >> | init_sfen_position | 4+L2nl/4+R2g1/p1+bp3g1/2p1p1ppp/5pk2/2P5P/PPNPP1S2/2G1G4/L2KS2+rL b S4p2nsb 1                                                                                                                                                                                       |
# >> |              moves | [{"t"=>140, "n"=>0, "m"=>"+0026GI"}, {"t"=>177, "n"=>1, "m"=>"-3544OU"}, {"t"=>132, "n"=>2, "m"=>"+7765KE"}, {"t"=>147, "n"=>3, "m"=>"-7395UM"}, {"t"=>121, "n"=>4, "m"=>"+5253RY"}, {"t"=>144, "n"=>5, "m"=>"-4455OU"}, {"t"=>98, "n"=>6, "m"=>"+5363RY"}, {"t"... |
# >> |--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |-----------+-------------------------------------------------------------------------------|
# >> |   対局KEY | shogi_GPT-yukky1119-20250226_161410                                           |
# >> |  対局日時 | 2025-02-26 16:14:10                                                           |
# >> |    ルール | 3分                                                                           |
# >> |      種類 | 野良                                                                          |
# >> |  開始局面 |                                                                               |
# >> |    手合割 | 平手                                                                          |
# >> |      結末 | 投了                                                                          |
# >> |  両者名前 | shogi_GPT:28級 vs yukky1119:29級                                              |
# >> |  勝った側 | △                                                                            |
# >> | 対局後か? | true                                                                          |
# >> | 対局中か? | false                                                                         |
# >> | 正常終了? | true                                                                          |
# >> | 棋譜有り? | true                                                                          |
# >> |  棋譜手数 | 24                                                                            |
# >> |  初期配置 | 4+L2nl/4+R2g1/p1+bp3g1/2p1p1ppp/5pk2/2P5P/PPNPP1S2/2G1G4/L2KS2+rL b S4p2nsb 1 |
# >> |-----------+-------------------------------------------------------------------------------|
