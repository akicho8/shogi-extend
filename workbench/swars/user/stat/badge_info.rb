require "./setup"
if_cond = Swars::User::Stat::BadgeInfo.fetch("金底マン").if_cond # => #<Proc:0x00000001207dd518 /Users/ikeda/src/shogi-extend/app/models/swars/user/stat/badge_info.rb:44 (lambda)>
Swars::User["BOUYATETSU5"].stat.instance_exec(&if_cond)          # => true
