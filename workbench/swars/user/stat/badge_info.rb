require "./setup"
if_cond = Swars::User::Stat::BadgeInfo.fetch("金底マン").if_cond # => #<Proc:0x0000000107abda80 /Users/ikeda/src/shogi-extend/app/models/swars/user/stat/badge_info.rb:47>
Swars::User["BOUYATETSU5"].stat.instance_eval(&if_cond)          # => false
