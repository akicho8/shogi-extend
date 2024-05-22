require "../setup"
user = Swars::User["SugarHuuko"]
_ { user.user_stat.think_stat.average } # => "131.72 ms"
_ { user.user_stat.think_stat.max     } # => "21.55 ms"
