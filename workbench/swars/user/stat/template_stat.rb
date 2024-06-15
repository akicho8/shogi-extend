require "./setup"
_ { Swars::User["SugarHuuko"].stat.template_stat.count } # => "145.95 ms"
s { Swars::User["SugarHuuko"].stat.template_stat.count } # => 50
tp Swars::User::Stat::TemplateStat.report
