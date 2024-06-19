require "./setup"
# _ { Swars::User["Dounannamari"].stat.skill_adjust_stat.count }        # => "188.36 ms"
# s { Swars::User["Dounannamari"].stat.skill_adjust_stat.count }        # => 14
s = Swars::Battle.all
s.average(:turn_max).to_i / 2            # => 44
