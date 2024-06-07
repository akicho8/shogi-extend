require "./setup"
user = Swars::User["SugarHuuko"]
_ { user.stat.think_stat.average } # => "131.72 ms"
_ { user.stat.think_stat.max     } # => "21.55 ms"
