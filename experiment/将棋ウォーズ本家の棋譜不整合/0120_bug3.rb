#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

ENV["INTEGRITY_VALIDATE"] = "true"

Swars::Battle.destroy_all
# Swars::Battle.user_import(run_remote: true, user_key: "shouracco", page_max: 1)
Swars::Battle.user_import(run_remote: true, user_key: "Lord_Asriel", page_max: 1)

# Swars::Battle.single_battle_import(run_remote: true, key: "fap34-StarCerisier-20200831_215840")
# Swars::Battle.single_battle_import(run_remote: true, key: "deefstar-StarCerisier-20200822_181008")
# Swars::Battle.single_battle_import(run_remote: true, key: "Kotakota3-StarCerisier-20200815_213555")
# Swars::Battle.single_battle_import(run_remote: true, key: "gessmanager-StarCerisier-20200909_231451")
# Swars::Battle.single_battle_import(run_remote: true, key: "StarCerisier-shogimonamour-20200909_222308")
# Swars::Battle.single_battle_import(run_remote: true, key: "yamasaki2017-StarCerisier-20200909_220047")
# Swars::Battle.single_battle_import(run_remote: true, key: "falcon39-StarCerisier-20200909_213410")

# Swars::Battle.single_battle_import(key: "falcon39-StarCerisier-20200909_213410")

# user = Swars::User.find_by(user_key: "StarCerisier")
# tp user.battles.count
# >> |-------------------------------------------------|
# >> | {:user_id=>"Lord_Asriel", :gtype=>"", :page=>1} |
# >> |-------------------------------------------------|
# >> |----------|
# >> | record:  |
# >> |----------|
# >> |----------|
# >> | record:  |
# >> |----------|
# >> #<Bioshogi::PieceNotFoundOnBoard: ６八に何もありません
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> |v香v桂v銀v金v玉 ・ ・v桂v香|一
# >> | ・v飛 ・ ・ ・ 銀 金v角 ・|二
# >> |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・v歩 ・ ・ ・ ・|六
# >> | 歩 歩 歩 歩 ・ 歩 歩 歩 歩|七
# >> | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
# >> | 香 桂 銀 金 玉 金 銀 桂 香|九
# >> +---------------------------+
# >> >
# >> ６八に何もありません
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> |v香v桂v銀v金v玉 ・ ・v桂v香|一
# >> | ・v飛 ・ ・ ・ 銀 金v角 ・|二
# >> |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・v歩 ・ ・ ・ ・|六
# >> | 歩 歩 歩 歩 ・ 歩 歩 歩 歩|七
# >> | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
# >> | 香 桂 銀 金 玉 金 銀 桂 香|九
# >> +---------------------------+
# >> https://shogiwars.heroz.jp/games/Lord_Asriel-Movadas-20200909_120551?locale=ja
# >> --------------------------------------------------------------------------------
# >> N+Lord_Asriel 4級
# >> N-Movadas 3級
# >> $START_TIME:2020/09/09 12:05:51
# >> $EVENT:将棋ウォーズ(10分切れ負け)
# >> $TIME_LIMIT:00:10+00
# >> +
# >> -4132KI
# >> T0
# >> +5756FU
# >> T1
# >> -3142GI
# >> T1
# >> +6857GI
# >> T0
# >> +7968GI
# >> T0
# >> -7162GI
# >> T1
# >> -4132KI
# >> T0
# >> +8879KA
# >> T1
# >> +5756FU
# >> T1
# >> -3334FU
# >> T0
# >> -3142GI
# >> T0
# >> +6857GI
# >> T0
# >> +2726FU
# >> T3
# >> -7162GI
# >> T1
# >> -4344FU
# >> T0
# >> +8879KA
# >> T1
# >> +2625FU
# >> T0
# >> -3334FU
# >> T0
# >> -2233KA
# >> T1
# >> +2726FU
# >> T1
# >> +5746GI
# >> T0
# >> -4344FU
# >> T0
# >> +2625FU
# >> T0
# >> -4243GI
# >> T1
# >> -2233KA
# >> T1
# >> +3736FU
# >> T0
# >> +5746GI
# >> T0
# >> -3342KA
# >> T3
# >> -4243GI
# >> T0
# >> +3635FU
# >> T0
# >> +3736FU
# >> T0
# >> -3342KA
# >> T2
# >> -2133KE
# >> T5
# >> +3635FU
# >> T0
# >> +3534FU
# >> T0
# >> -2133KE
# >> T4
# >> -4334GI
# >> T2
# >> +3534FU
# >> T0
# >> +4635GI
# >> T2
# >> -4334GI
# >> T2
# >> -3435GI
# >> T0
# >> +4635GI
# >> T2
# >> +7935KA
# >> T1
# >> -3435GI
# >> T0
# >> -0043GI
# >> T1
# >> +7935KA
# >> T1
# >> +2524FU
# >> T4
# >> -0043GI
# >> T1
# >> -2324FU
# >> T0
# >> +3524KA
# >> T9
# >> +2524FU
# >> T1
# >> -0023FU
# >> T0
# >> -2324FU
# >> T0
# >> +2479KA
# >> T9
# >> +3524KA
# >> T6
# >> -0034FU
# >> T0
# >> -0023FU
# >> T0
# >> +3948GI
# >> T25
# >> -6364FU
# >> T5
# >> +2479KA
# >> T0
# >> +6978KI
# >> T26
# >> -0034FU
# >> T0
# >> -6263GI
# >> T0
# >> +3948GI
# >> T25
# >> +4837GI
# >> T24
# >> -6364FU
# >> T0
# >> -6172KI
# >> T0
# >> +6978KI
# >> T26
# >> +5969OU
# >> T24
# >> -6263GI
# >> T0
# >> -5162OU
# >> T0
# >> +4837GI
# >> T24
# >> +3746GI
# >> T28
# >> -6172KI
# >> T0
# >> -7374FU
# >> T0
# >> +5969OU
# >> T24
# >> +2937KE
# >> T37
# >> -5162OU
# >> T0
# >> -8173KE
# >> T0
# >> +3746GI
# >> T28
# >> -7374FU
# >> T0
# >> +1716FU
# >> T43
# >> +2937KE
# >> T37
# >> -8281HI
# >> T0
# >> -8173KE
# >> T0
# >> +1615FU
# >> T94
# >> +1716FU
# >> T69
# >> -6354GI
# >> T0
# >> -8281HI
# >> T0
# >> +4655GI
# >> T93
# >> +1615FU
# >> T94
# >> -5455GI
# >> T0
# >> -6354GI
# >> T0
# >> +4655GI
# >> T91
# >> +5655FU
# >> T94
# >> -5455GI
# >> T0
# >> -8151HI
# >> T0
# >> +5655FU
# >> T92
# >> +2858HI
# >> T93
# >> -8151HI
# >> T0
# >> -5354FU
# >> T0
# >> +2858HI
# >> T93
# >> +5554FU
# >> T94
# >> -5354FU
# >> T0
# >> -4354GI
# >> T0
# >> +5554FU
# >> T94
# >> -4354GI
# >> T0
# >> +4746FU
# >> T8
# >> +4746FU
# >> T101
# >> -5455GI
# >> T0
# >> -5455GI
# >> T0
# >> %CHUDAN
# >> --------------------------------------------------------------------------------
