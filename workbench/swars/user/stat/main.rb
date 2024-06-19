require "./setup"
# _ { Swars::User["HIKOUKI_GUMO"].stat(sample_max: 200).to_hash } # => "601.95 ms"
# _ { Swars::User["HIKOUKI_GUMO"].stat(sample_max: 200).to_hash } # => "384.90 ms"

# s = Swars::Membership.joins(:battle => :final).where(Swars::Final.arel_table[:key].eq(:TORYO))
# s = s.group(Swars::Battle.arel_table[:turn_max])
# s = s.order(Swars::Battle.arel_table[:turn_max])
# p s.count

s = Swars::Membership
s = s.joins(:battle => :final)
s = s.joins(:judge)
s = s.joins(:user)
s = s.where(Judge.arel_table[:key].eq(:lose))
s = s.where(Swars::Final.arel_table[:key].eq(:TORYO))
s = s.where(Swars::Battle.arel_table[:turn_max].lteq(14))
s = s.order("count_all DESC")
s = s.having("count_all >= 10")
s = s.group(Swars::User.arel_table[:key])
# s.collect { |e| e.user.key }
tp s.count
# >> |----------------+-----|
# >> |        OdenCan | 188 |
# >> |   Dounannamari | 134 |
# >> |         ayashi | 80  |
# >> |       TERINA_q | 72  |
# >> |           HQCD | 54  |
# >> | cup_noodle_big | 47  |
# >> |      PE_CO0727 | 39  |
# >> |  old_rookie_ch | 38  |
# >> |    namepukingX | 34  |
# >> |         mmaamm | 29  |
# >> |       pio_city | 28  |
# >> |     micro77fan | 27  |
# >> |       kdss1122 | 27  |
# >> |       kouuk429 | 27  |
# >> |      ajakong89 | 26  |
# >> |    877_moon___ | 24  |
# >> |   kage__noboru | 23  |
# >> | sirokurotiwawa | 23  |
# >> |          uzo77 | 23  |
# >> |  ultrasoul2024 | 21  |
# >> |   Kingkong2024 | 20  |
# >> |     yakkun4649 | 19  |
# >> |        mai5254 | 19  |
# >> |      TheMakino | 17  |
# >> |       sumi2000 | 16  |
# >> |         sai369 | 16  |
# >> |      H_Britney | 15  |
# >> |      justifaiz | 15  |
# >> |     kagepoyo81 | 14  |
# >> |         Cyorey | 14  |
# >> |         kukach | 14  |
# >> |         B_MAX_ | 14  |
# >> |       tomosa11 | 13  |
# >> |        cobo923 | 13  |
# >> |       kano2021 | 12  |
# >> |      tsuneutsu | 12  |
# >> | Old_Rookie_Rev | 12  |
# >> | 1997Omegatribe | 12  |
# >> |      Big_Ben_3 | 11  |
# >> |          gegio | 11  |
# >> |  koumeibashoku | 11  |
# >> |    Qwerty12358 | 11  |
# >> |    HyperGodRyo | 11  |
# >> |    ryokutyan41 | 10  |
# >> |       osaru000 | 10  |
# >> |       JOYPONKO | 10  |
# >> |       hidabeef | 10  |
# >> |       pinpho36 | 10  |
# >> |----------------+-----|
