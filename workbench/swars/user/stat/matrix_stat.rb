require "./setup"
_ { Swars::User["SugarHuuko"].stat(sample_max: 200).matrix_stat.to_all_chart } # => "281.35 ms"
stat = Swars::User["SugarHuuko"].stat
stat.matrix_stat.tag_chart_build(stat.op_tag_stat, )

