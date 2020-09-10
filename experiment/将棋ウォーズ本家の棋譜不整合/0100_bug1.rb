#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

Swars::Battle.destroy_all
# Swars::Battle.user_import(run_remote: true, user_key: "StarCerisier", page_max: 2)

# Swars::Battle.single_battle_import(run_remote: true, key: "fap34-StarCerisier-20200831_215840")
# Swars::Battle.single_battle_import(run_remote: true, key: "deefstar-StarCerisier-20200822_181008")
# Swars::Battle.single_battle_import(run_remote: true, key: "Kotakota3-StarCerisier-20200815_213555")
# Swars::Battle.single_battle_import(run_remote: true, key: "gessmanager-StarCerisier-20200909_231451")
# Swars::Battle.single_battle_import(run_remote: true, key: "StarCerisier-shogimonamour-20200909_222308")
# Swars::Battle.single_battle_import(run_remote: true, key: "yamasaki2017-StarCerisier-20200909_220047")
Swars::Battle.single_battle_import(run_remote: true, key: "falcon39-StarCerisier-20200909_213410")

# Swars::Battle.single_battle_import(key: "falcon39-StarCerisier-20200909_213410")

user = Swars::User.find_by(user_key: "StarCerisier")
tp user.battles.count
# >> |----------|
# >> | record:  |
# >> |----------|
# >> "falcon39-StarCerisier-20200909_213410"
# >> 歩を持っていません : {:bishop=>1, :silver=>1}
# >> |--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                 id |                                                                                                                                                                                                                                                                     |
# >> |                key | falcon39-StarCerisier-20200909_213410                                                                                                                                                                                                                               |
# >> |         battled_at | 2020-09-09 21:34:10 +0900                                                                                                                                                                                                                                           |
# >> |           rule_key | three_min                                                                                                                                                                                                                                                           |
# >> |            csa_seq | [["+7776FU", 180], ["-3334FU", 179], ["+7675FU", 179], ["-5142OU", 176], ["+2868HI", 178], ["-7162GI", 171], ["+5948OU", 177], ["-1314FU", 169], ["+1716FU", 176], ["-6364FU", 168], ["+4838OU", 175], ["-6263GI", 167], ["+3828OU", 174], ["-4232OU", 165], ["+... |
# >> |          final_key | TIMEOUT                                                                                                                                                                                                                                                             |
# >> |        win_user_id | 8                                                                                                                                                                                                                                                                   |
# >> |           turn_max | 0                                                                                                                                                                                                                                                                   |
# >> |          meta_info | {}                                                                                                                                                                                                                                                                  |
# >> |        accessed_at | 2020-09-10 09:32:53 +0900                                                                                                                                                                                                                                           |
# >> |      outbreak_turn |                                                                                                                                                                                                                                                                     |
# >> |         created_at |                                                                                                                                                                                                                                                                     |
# >> |         updated_at |                                                                                                                                                                                                                                                                     |
# >> |         preset_key | 平手                                                                                                                                                                                                                                                                |
# >> |         start_turn |                                                                                                                                                                                                                                                                     |
# >> |      critical_turn |                                                                                                                                                                                                                                                                     |
# >> |          sfen_body |                                                                                                                                                                                                                                                                     |
# >> |         image_turn |                                                                                                                                                                                                                                                                     |
# >> |          sfen_hash |                                                                                                                                                                                                                                                                     |
# >> |   defense_tag_list |                                                                                                                                                                                                                                                                     |
# >> |    attack_tag_list |                                                                                                                                                                                                                                                                     |
# >> | technique_tag_list |                                                                                                                                                                                                                                                                     |
# >> |      note_tag_list |                                                                                                                                                                                                                                                                     |
# >> |     other_tag_list |                                                                                                                                                                                                                                                                     |
# >> |--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> N+falcon39 四段
# >> N-StarCerisier 四段
# >> $START_TIME:2020/09/09 21:34:10
# >> $EVENT:将棋ウォーズ(3分切れ負け)
# >> $TIME_LIMIT:00:03+00
# >> +
# >> +7776FU
# >> T0
# >> -3334FU
# >> T1
# >> +7675FU
# >> T1
# >> -5142OU
# >> T3
# >> +2868HI
# >> T1
# >> -7162GI
# >> T5
# >> +5948OU
# >> T1
# >> -1314FU
# >> T2
# >> +1716FU
# >> T1
# >> -6364FU
# >> T1
# >> +4838OU
# >> T1
# >> -6263GI
# >> T1
# >> +3828OU
# >> T1
# >> -4232OU
# >> T2
# >> +3938GI
# >> T1
# >> -8384FU
# >> T3
# >> +6878HI
# >> T1
# >> -8485FU
# >> T3
# >> +7876HI
# >> T0
# >> -2288UM
# >> T3
# >> +7988GI
# >> T1
# >> -3122GI
# >> T1
# >> +6978KI
# >> T1
# >> -2233GI
# >> T2
# >> +8877GI
# >> T1
# >> -3344GI
# >> T2
# >> +7766GI
# >> T1
# >> -4142KI
# >> T1
# >> +5756FU
# >> T1
# >> -5354FU
# >> T2
# >> +8977KE
# >> T2
# >> -9394FU
# >> T25
# >> +6657GI
# >> T5
# >> -6172KI
# >> T5
# >> +5746GI
# >> T1
# >> -9495FU
# >> T6
# >> +9796FU
# >> T4
# >> -9596FU
# >> T2
# >> +9996KY
# >> T1
# >> -0095FU
# >> T2
# >> +9695KY
# >> T2
# >> -9195KY
# >> T1
# >> +0096FU
# >> T1
# >> -0089KA
# >> T3
# >> +7868KI
# >> T3
# >> -8998UM
# >> T2
# >> +9695FU
# >> T1
# >> -9887UM
# >> T1
# >> +7666HI
# >> T13
# >> -0065KY
# >> T1
# >> +0045KY
# >> T3
# >> -6566KY
# >> T2
# >> +4544KY
# >> T1
# >> -4344FU
# >> T1
# >> +6766FU
# >> T2
# >> -0098HI
# >> T2
# >> +4657GI
# >> T5
# >> -5455FU
# >> T5
# >> +6858KI
# >> T13
# >> -8776UM
# >> T2
# >> +0059KY
# >> T6
# >> -7677UM
# >> T2
# >> +5655FU
# >> T1
# >> -8586FU
# >> T6
# >> +0083FU
# >> T10
# >> -8283HI
# >> T2
# >> +4746FU
# >> T8
# >> -8687TO
# >> T1
# >> +4645FU
# >> T1
# >> -4445FU
# >> T2
# >> +0044FU
# >> T2
# >> -0031KE
# >> T2
# >> -0042FU
# >> T53
# >> +0054GI
# >> T0
# >> -6352GI
# >> T0
# >> +0094KA
# >> T11
# >> -8382HI
# >> T1
# >> +5445GI
# >> T2
# >> -7262KI
# >> T8
# >> +5554FU
# >> T7
# >> -8778TO
# >> T1
# >> +0083FU
# >> T4
# >> -8292HI
# >> T3
# >> +4534GI
# >> T5
# >> -0033FU
# >> T2
# >> +4443TO
# >> T1
# >> -3143KE
# >> T2
# >> +3445GI
# >> T1
# >> -0044FU
# >> T2
# >> +4544GI
# >> T1
# >> -7869TO
# >> T2
# >> +5453TO
# >> T11
# >> -5253GI
# >> T2
# >> +4453NG
# >> T1
# >> -6253KI
# >> T1
# >> +0054FU
# >> T2
# >> -5354KI
# >> T1
# >> +8382TO
# >> T1
# >> -9282HI
# >> T1
# >> +9461UM
# >> T2
# >> -6959TO
# >> T1
# >> +5859KI
# >> T1
# >> -9899RY
# >> T3
# >> +5948KI
# >> T2
# >> -0044KY
# >> T2
# >> +0045FU
# >> T2
# >> -5445KI
# >> T1
# >> +0046FU
# >> T4
# >> -4555KI
# >> T2
# >> +6171UM
# >> T1
# >> -8289RY
# >> T2
# >> +7144UM
# >> T2
# >> -0056FU
# >> T1
# >> +0053GI
# >> T3
# >> -4241KI
# >> T2
# >> +0045KY
# >> T4
# >> -0042FU
# >> T1
# >> +5756GI
# >> T5
# >> +5756GI
# >> T22
# >> -5556KI
# >> T0
# >> +6665FU
# >> T1
# >> -7744UM
# >> T2
# >> -5556KI
# >> T0
# >> +5344NG
# >> T22
# >> -5646KI
# >> T3
# >> +6665FU
# >> T0
# >> +0077KA
# >> T23
# >> -7744UM
# >> T0
# >> -9997RY
# >> T0
# >> +4443NG
# >> T25
# >> -4243FU
# >> T1
# >> +7766KA
# >> T1
# >> -8969RY
# >> T2
# >> +5344NG
# >> T0
# >> -5646KI
# >> T0
# >> +0077KA
# >> T2
# >> -9997RY
# >> T2
# >> +4443NG
# >> T1
# >> -4243FU
# >> T1
# >> +7766KA
# >> T1
# >> -8969RY
# >> T2
# >> %TIME_UP
