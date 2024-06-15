require "./setup"
# tp Swars::User["yomeP"].stat(sample_max: 0).gentleman_stat.to_a
# tp Swars::User["yomeP"].stat.gentleman_stat.to_a
# tp Swars::User["staygold3377"].stat.gentleman_stat.to_a
# tp Swars::User["Sushi_Kuine"].stat.gentleman_stat.to_a
# tp Swars::User.create!.stat(sample_max: 200).gentleman_stat.to_a
# tp Swars::User["Ito_Shingo"].stat(sample_max: 200).gentleman_stat.to_a
# tp Swars::User["SugarHuuko"].stat(sample_max: 200).gentleman_stat.to_a
# Swars::User["SugarHuuko"].stat(sample_max: 200).xmode_judge_stat.friend_kill_ratio # => 0.25
# exit
# tp Swars::User["slowstep3210"].stat(sample_max: 10).gentleman_stat.to_a
# tp Swars::User["takayukiando"].stat(sample_max: 200).gentleman_stat.to_a
# tp Swars::User["BOUYATETSU5"].stat(sample_max: 200).gentleman_stat.to_a
# tp Swars::User["doradoracat"].stat(sample_max: 200).gentleman_stat.to_a

# Swars::User["staygold3377"].stat(sample_max: 200).xmode_judge_stat.friend_kill_ratio # => nil
# exit
tp Swars::User::Stat::GentlemanStat.report(sample_max: 200)
