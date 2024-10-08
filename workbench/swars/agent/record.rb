require "./setup"
info = Swars::Agent::Record.new(remote_run: true, key: Swars::BattleKey["THE_LAST_WISH-443443443-20240426_200052"]).fetch
tp Swars::Agent::PropsAdapter.new(info).to_h

puts Swars::Battle["THE_LAST_WISH-443443443-20240426_200052"].to_temporary_csa
# >> |-----------+-----------------------------------------|
# >> |   対局KEY | THE_LAST_WISH-443443443-20240426_200052 |
# >> |  対局日時 | 2024-04-26 20:00:52                     |
# >> |    ルール | 3分                                     |
# >> |      種類 | 野良                                    |
# >> |    手合割 | 平手                                    |
# >> |      結末 | 入玉                                    |
# >> |  両者名前 | THE_LAST_WISH:九段 vs 443443443:九段    |
# >> |  勝った側 | △                                      |
# >> | 対局後か? | true                                    |
# >> | 対局中か? | false                                   |
# >> | 正常終了? | true                                    |
# >> | 棋譜有り? | true                                    |
# >> |  棋譜手数 | 225                                     |
# >> |-----------+-----------------------------------------|
# >> N+THE_LAST_WISH 九段
# >> N-443443443 九段
# >> $START_TIME:2024/04/26 20:00:52
# >> $EVENT:将棋ウォーズ(3分切れ負け)
# >> $TIME_LIMIT:00:03+00
# >> +
# >> +7776FU,T0
# >> -8384FU,T1
# >> +2726FU,T2
# >> -4132KI,T3
# >> +2625FU,T3
# >> -8485FU,T1
# >> +8877KA,T0
# >> -3334FU,T1
# >> +7968GI,T1
# >> -2277UM,T2
# >> +6877GI,T1
# >> -3122GI,T0
# >> +6978KI,T1
# >> -1314FU,T1
# >> +5968OU,T0
# >> -7162GI,T1
# >> +3948GI,T1
# >> -2233GI,T2
# >> +6879OU,T0
# >> -9394FU,T1
# >> +4958KI,T1
# >> -9495FU,T1
# >> +4859GI,T1
# >> -1415FU,T2
# >> +5968GI,T0
# >> -5142OU,T1
# >> +7988OU,T1
# >> -4231OU,T1
# >> +6879GI,T0
# >> -6151KI,T1
# >> +5868KI,T1
# >> -5142KI,T3
# >> +9998KY,T0
# >> -3122OU,T3
# >> +8899OU,T1
# >> -1112KY,T1
# >> +7988GI,T1
# >> -2211OU,T1
# >> +1716FU,T0
# >> -1516FU,T1
# >> +2524FU,T1
# >> -2324FU,T2
# >> +2826HI,T0
# >> -0049KA,T4
# >> +1916KY,T1
# >> -4916UM,T1
# >> +2616HI,T1
# >> -1216KY,T2
# >> +0017FU,T1
# >> -0028HI,T2
# >> +1716FU,T1
# >> -2829RY,T2
# >> +0079KY,T0
# >> -1122OU,T2
# >> +1615FU,T1
# >> -2918RY,T2
# >> +1514FU,T0
# >> -1814RY,T2
# >> +4746FU,T1
# >> -1419RY,T2
# >> +3736FU,T1
# >> -2213OU,T2
# >> +4645FU,T0
# >> -0016FU,T2
# >> +4544FU,T1
# >> -3344GI,T1
# >> +3635FU,T0
# >> -3435FU,T3
# >> +7675FU,T2
# >> -1617TO,T1
# >> +7574FU,T1
# >> -1727TO,T2
# >> +7473TO,T1
# >> -6273GI,T2
# >> +6766FU,T1
# >> -1314OU,T2
# >> +0074FU,T1
# >> -7364GI,T2
# >> +6665FU,T2
# >> -6455GI,T2
# >> +5756FU,T0
# >> -5546GI,T2
# >> +0066KA,T3
# >> -4233KI,T2
# >> +6867KI,T4
# >> -1425OU,T2
# >> +6768KI,T1
# >> -3536FU,T2
# >> +6867KI,T4
# >> -3637TO,T2
# >> +6768KI,T0
# >> -0036FU,T2
# >> +6867KI,T1
# >> -4635GI,T2
# >> +6768KI,T1
# >> -0016FU,T2
# >> +6867KI,T0
# >> -1617TO,T2
# >> +7776GI,T1
# >> -0015FU,T2
# >> +7675GI,T1
# >> -2726TO,T2
# >> +7473TO,T1
# >> -8173KE,T1
# >> +7574GI,T1
# >> -0071KY,T4
# >> +6777KI,T5
# >> -1727TO,T1
# >> +7776KI,T1
# >> -7365KE,T2
# >> +7465GI,T1
# >> -6364FU,T2
# >> +6564GI,T0
# >> -7176KY,T2
# >> +0077FU,T1
# >> -0065FU,T4
# >> +6675KA,T1
# >> -0066KE,T1
# >> +7566KA,T3
# >> -6566FU,T2
# >> +7776FU,T1
# >> -8586FU,T2
# >> +8786FU,T1
# >> -6667TO,T2
# >> +7867KI,T1
# >> -0087FU,T2
# >> +8887GI,T2
# >> -1979RY,T2
# >> +0088KA,T1
# >> -7929RY,T2
# >> +6768KI,T3
# >> -0061KY,T2
# >> +0063FU,T1
# >> -0079KI,T2
# >> +8879KA,T1
# >> -2979RY,T2
# >> +0078KI,T0
# >> -7919RY,T2
# >> +0079KY,T1
# >> -5354FU,T1
# >> +6473NG,T1
# >> -8292HI,T2
# >> +6362TO,T1
# >> -6162KY,T2
# >> +0063FU,T0
# >> -6263KY,T4
# >> +7363NG,T1
# >> -3747TO,T1
# >> +6364NG,T5
# >> -5455FU,T2
# >> +6465NG,T1
# >> -5556FU,T2
# >> +0058FU,T0
# >> -3637TO,T2
# >> +6566NG,T1
# >> -2516OU,T1
# >> +6656NG,T1
# >> -1617OU,T1
# >> +0045FU,T0
# >> -4453GI,T2
# >> +0065KE,T2
# >> -5364GI,T1
# >> +0067KE,T0
# >> -1718OU,T2
# >> +5655NG,T1
# >> -6455GI,T1
# >> +6755KE,T0
# >> -1516FU,T0
# >> +6553NK,T1
# >> -1617TO,T2
# >> +5543NK,T1
# >> -3243KI,T1
# >> +5343NK,T1
# >> -3343KI,T0
# >> +4544FU,T0
# >> -4344KI,T1
# >> +6857KI,T1
# >> -4757TO,T1
# >> +5857FU,T1
# >> -2738TO,T1
# >> +0039FU,T1
# >> -3839TO,T1
# >> +0036FU,T0
# >> -3536GI,T1
# >> +0046KY,T1
# >> -3627NG,T1
# >> +4644KY,T1
# >> -2738NG,T1
# >> +0046GI,T0
# >> -3747TO,T1
# >> +4635GI,T2
# >> -2627TO,T1
# >> +0026KI,T0
# >> -2726TO,T1
# >> +3526GI,T1
# >> -0027GI,T1
# >> +2617GI,T1
# >> -1817OU,T1
# >> +0048FU,T0
# >> -4748TO,T1
# >> +0029FU,T1
# >> -3929TO,T1
# >> +4441NY,T1
# >> -0047KI,T1
# >> +0046KI,T0
# >> -4746KI,T1
# >> +4131NY,T2
# >> -0047GI,T2
# >> +3121NY,T0
# >> -0037KI,T1
# >> +7868KI,T1
# >> -0049KI,T1
# >> +0039KE,T0
# >> -4939KI,T1
# >> +6858KI,T1
# >> -0049KA,T1
# >> +5847KI,T1
# >> -4647KI,T1
# >> +0026GI,T1
# >> -1726OU,T1
# >> +8778GI,T1
# >> -2617OU,T1
# >> +7867GI,T0
# >> -0028KI,T1
# >> +6758GI,T2
# >> %KACHI
