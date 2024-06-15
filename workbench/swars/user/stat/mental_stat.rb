require "./setup"
_ { Swars::User["SugarHuuko"].stat.mental_stat.level     } # => "233.92 ms"
s { Swars::User["SugarHuuko"].stat.mental_stat.level     } # => -3
s { Swars::User["SugarHuuko"].stat.mental_stat.raw_level } # => -5.019
tp Swars::User::Stat::MentalStat.report
