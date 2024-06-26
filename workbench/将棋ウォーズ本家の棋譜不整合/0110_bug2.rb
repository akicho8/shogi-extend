#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

Swars.setup

user1 = Swars::User.create!
user2 = Swars::User.create!
Swars::Battle.destroy_all

# p Swars::Agent::Record.fetch(remote_run: true, key: "falcon39-StarCerisier-20200909_213410")
# exit
r = Swars::Battle.new
r.memberships.build(user: user1, grade: Swars::Grade.last)
r.memberships.build(user: user2, grade: Swars::Grade.last)
r.key = SecureRandom.hex
r.rule_key = "three_min"
r.csa_seq = [["+7776FU", 180], ["-3334FU", 179], ["+7675FU", 179], ["-5142OU", 176], ["+2868HI", 178], ["-7162GI", 171], ["+5948OU", 177], ["-1314FU", 169], ["+1716FU", 176], ["-6364FU", 168], ["+4838OU", 175], ["-6263GI", 167], ["+3828OU", 174], ["-4232OU", 165], ["+3938GI", 173], ["-8384FU", 162], ["+6878HI", 172], ["-8485FU", 159], ["+7876HI", 172], ["-2288UM", 156], ["+7988GI", 171], ["-3122GI", 155], ["+6978KI", 170], ["-2233GI", 153], ["+8877GI", 169], ["-3344GI", 151], ["+7766GI", 168], ["-4142KI", 150], ["+5756FU", 167], ["-5354FU", 148], ["+8977KE", 165], ["-9394FU", 123], ["+6657GI", 160], ["-6172KI", 118], ["+5746GI", 159], ["-9495FU", 112], ["+9796FU", 155], ["-9596FU", 110], ["+9996KY", 154], ["-0095FU", 108], ["+9695KY", 152], ["-9195KY", 107], ["+0096FU", 151], ["-0089KA", 104], ["+7868KI", 148], ["-8998UM", 102], ["+9695FU", 147], ["-9887UM", 101], ["+7666HI", 134], ["-0065KY", 100], ["+0045KY", 131], ["-6566KY", 98], ["+4544KY", 130], ["-4344FU", 97], ["+6766FU", 128], ["-0098HI", 95], ["+4657GI", 123], ["-5455FU", 90], ["+6858KI", 110], ["-8776UM", 88], ["+0059KY", 104], ["-7677UM", 86], ["+5655FU", 103], ["-8586FU", 80], ["+0083FU", 93], ["-8283HI", 78], ["+4746FU", 85], ["-8687TO", 77], ["+4645FU", 84], ["-4445FU", 75], ["+0044FU", 82], ["-0031KE", 73], ["-0042FU", 29], ["+0054GI", 80], ["-6352GI", 70], ["+0094KA", 69], ["-8382HI", 69], ["+5445GI", 67], ["-7262KI", 61], ["+5554FU", 60], ["-8778TO", 60], ["+0083FU", 56], ["-8292HI", 57], ["+4534GI", 51], ["-0033FU", 55], ["+4443TO", 50], ["-3143KE", 53], ["+3445GI", 49], ["-0044FU", 51], ["+4544GI", 48], ["-7869TO", 49], ["+5453TO", 37], ["-5253GI", 47], ["+4453NG", 36], ["-6253KI", 46], ["+0054FU", 34], ["-5354KI", 45], ["+8382TO", 33], ["-9282HI", 44], ["+9461UM", 31], ["-6959TO", 43], ["+5859KI", 30], ["-9899RY", 40], ["+5948KI", 28], ["-0044KY", 38], ["+0045FU", 26], ["-5445KI", 37], ["+0046FU", 22], ["-4555KI", 35], ["+6171UM", 21], ["-8289RY", 33], ["+7144UM", 19], ["-0056FU", 32], ["+0053GI", 16], ["-4241KI", 30], ["+0045KY", 12], ["-0042FU", 29], ["+5756GI", 7], ["+5756GI", 7], ["-5556KI", 28], ["+6665FU", 6], ["-7744UM", 26], ["-5556KI", 28], ["+5344NG", 4], ["-5646KI", 25], ["+6665FU", 6], ["+0077KA", 2], ["-7744UM", 26], ["-9997RY", 23], ["+4443NG", 1], ["-4243FU", 22], ["+7766KA", 0], ["-8969RY", 20], ["+5344NG", 4], ["-5646KI", 25], ["+0077KA", 2], ["-9997RY", 23], ["+4443NG", 1], ["-4243FU", 22], ["+7766KA", 0], ["-8969RY", 20]]
r.preset_key = "平手"
r.battled_at = Time.current
r.final_key = "TORYO"
puts r.kifu_body
# >> N+user47 30級
# >> N-user48 30級
# >> $START_TIME:2020/09/10 00:48:04
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
# >> %TORYO
