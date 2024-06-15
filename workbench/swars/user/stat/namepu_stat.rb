require "./setup"
# _ { Swars::User["SugarHuuko"].stat.gdiff_stat.average          } # => "154.56 ms"
# s { Swars::User["SugarHuuko"].stat.gdiff_stat.average          } # => -0.436e1
# s { Swars::User["SugarHuuko"].stat.gdiff_stat.abs              } # => 0.436e1
# Swars::User.create!.stat.gdiff_stat.average # => nil
# Swars::User.create!.stat.gdiff_stat.abs     # => nil

# s { Swars::User.create!.stat.gdiff_stat.reverse_kiryoku_sagi_count } # => 0
# s { Swars::User["Taichan0601"].stat.gdiff_stat.reverse_kiryoku_sagi_count } # => 23
tp Swars::User::Stat::NamepuStat.report(sample_max: 200)
