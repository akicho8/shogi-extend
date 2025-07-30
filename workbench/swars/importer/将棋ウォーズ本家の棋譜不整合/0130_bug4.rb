#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)
ENV["INTEGRITY_VALIDATE"] = "true"
# Swars::Battle.destroy_all
Swars::Importer::FullHistoryImporter.new(remote_run: true, user_key: "Myan_yade", look_up_to_page_x: 1).call

# Swars::Importer::FullHistoryImporter.new(remote_run: true, user_key: "Lord_Asriel", look_up_to_page_x: 1).call

# Swars::Importer::BattleImporter.new(remote_run: true, key: "fap34-StarCerisier-20200831_215840").call
# Swars::Importer::BattleImporter.new(remote_run: true, key: "deefstar-StarCerisier-20200822_181008").call
# Swars::Importer::BattleImporter.new(remote_run: true, key: "Kotakota3-StarCerisier-20200815_213555").call
# Swars::Importer::BattleImporter.new(remote_run: true, key: "gessmanager-StarCerisier-20200909_231451").call
# Swars::Importer::BattleImporter.new(remote_run: true, key: "StarCerisier-shogimonamour-20200909_222308").call
# Swars::Importer::BattleImporter.new(remote_run: true, key: "yamasaki2017-StarCerisier-20200909_220047").call
# Swars::Importer::BattleImporter.new(remote_run: true, key: "falcon39-StarCerisier-20200909_213410").call

# Swars::Importer::BattleImporter.new(key: "falcon39-StarCerisier-20200909_213410").call

# user = Swars::User.find_by(user_key: "StarCerisier")
# tp user.battles.count
# >> |-----------------------------------------------|
# >> | {:user_id=>"shouracco", :gtype=>"", :page=>1} |
# >> |-----------------------------------------------|
# >> |----------|
# >> | record:  |
# >> |----------|
# >> |----------|
# >> | record:  |
# >> |----------|
# >> |----------|
# >> | record:  |
# >> |----------|
# >> |----------|
# >> | record:  |
# >> |----------|
# >> |----------|
# >> | record:  |
# >> |----------|
# >> |----------|
# >> | record:  |
# >> |----------|
# >> #<Bioshogi::PieceNotFoundOnBoard: ２六に何もありません
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> |v香v桂v玉v金 ・ 馬 ・ ・ ・|一
# >> | ・ ・v銀 ・ ・v銀 ・ ・ ・|二
# >> |v歩v歩v歩v歩v歩v歩 ・ ・ ・|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・v歩|四
# >> | ・ ・ ・ 歩 ・ ・ ・ ・ ・|五
# >> | ・ ・ 歩 ・ ・ ・ 銀 ・ 歩|六
# >> | 歩 歩 ・ ・ ・ 歩 歩 ・ ・|七
# >> | ・ 金 ・ 玉 ・ ・ 金v杏 ・|八
# >> | 香 桂 ・ ・ ・ ・ 香 ・v龍|九
# >> +---------------------------+
# >> >
# >> ２六に何もありません
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> |v香v桂v玉v金 ・ 馬 ・ ・ ・|一
# >> | ・ ・v銀 ・ ・v銀 ・ ・ ・|二
# >> |v歩v歩v歩v歩v歩v歩 ・ ・ ・|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・v歩|四
# >> | ・ ・ ・ 歩 ・ ・ ・ ・ ・|五
# >> | ・ ・ 歩 ・ ・ ・ 銀 ・ 歩|六
# >> | 歩 歩 ・ ・ ・ 歩 歩 ・ ・|七
# >> | ・ 金 ・ 玉 ・ ・ 金v杏 ・|八
# >> | 香 桂 ・ ・ ・ ・ 香 ・v龍|九
# >> +---------------------------+
# >> https://shogiwars.heroz.jp/games/manbowd-shouracco-20200905_171817?locale=ja
# >> --------------------------------------------------------------------------------
# >> N+manbowd 2級
# >> N-shouracco 1級
# >> $START_TIME:2020/09/05 17:18:17
# >> $EVENT:将棋ウォーズ(10分切れ負け)
# >> $TIME_LIMIT:00:10+00
# >> +
# >> +7776FU
# >> T0
# >> -3334FU
# >> T0
# >> +6766FU
# >> T1
# >> -3435FU
# >> T0
# >> +7968GI
# >> T2
# >> -8232HI
# >> T0
# >> +6867GI
# >> T1
# >> -5162OU
# >> T0
# >> +6756GI
# >> T1
# >> -3142GI
# >> T0
# >> +2868HI
# >> T2
# >> -1314FU
# >> T0
# >> +1716FU
# >> T2
# >> -3536FU
# >> T0
# >> +3736FU
# >> T1
# >> -3236HI
# >> T0
# >> +0037FU
# >> T2
# >> -3634HI
# >> T0
# >> +6978KI
# >> T4
# >> -7172GI
# >> T0
# >> +6665FU
# >> T1
# >> -2288UM
# >> T0
# >> +7888KI
# >> T2
# >> -6271OU
# >> T0
# >> +0022KA
# >> T5
# >> -0013KA
# >> T0
# >> +2211UM
# >> T6
# >> -1357UM
# >> T0
# >> +5645GI
# >> T6
# >> -3424HI
# >> T0
# >> +1121UM
# >> T12
# >> -2427RY
# >> T0
# >> +0028KY
# >> T7
# >> -5768UM
# >> T0
# >> +5968OU
# >> T1
# >> -2728RY
# >> T0
# >> +3928GI
# >> T2
# >> -0024KY
# >> T0
# >> +0027KE
# >> T5
# >> -2427NY
# >> T0
# >> +2827GI
# >> T5
# >> -0028HI
# >> T0
# >> +4938KI
# >> T1
# >> -2829RY
# >> T0
# >> +0039KY
# >> T2
# >> -2919RY
# >> T0
# >> +2122UM
# >> T13
# >> -0024KY
# >> T0
# >> +4536GI
# >> T5
# >> -0026KE
# >> T0
# >> +2726GI
# >> T15
# >> -2426KY
# >> T0
# >> +2223UM
# >> T1
# >> -2628NY
# >> T0
# >> +2341UM
# >> T16
# >> -2628KY
# >> T0
# >> %CHUDAN
# >> --------------------------------------------------------------------------------
