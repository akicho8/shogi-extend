require "./setup"
_ { Swars::User["SugarHuuko"].stat.think_stat.average } # => "157.55 ms"
_ { Swars::User["SugarHuuko"].stat.think_stat.max     } # => "20.78 ms"
tp Swars::User::Stat::ThinkStat.report
