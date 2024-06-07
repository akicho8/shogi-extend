require "./setup"
Swars::User["SugarHuuko"].stat(sample_max: 200).xmode_stat.count(:"野良") # => 199
Swars::User["SugarHuuko"].stat(sample_max: 200).xmode_stat.count(:"指導") # => 1
Swars::User["SugarHuuko"].stat(sample_max: 200).xmode_judge_stat.counts_hash # => {["野良", "win"]=>142, ["野良", "lose"]=>52, ["指導", "win"]=>1, ["野良", "draw"]=>5}
Swars::User["SugarHuuko"].stat(sample_max: 200).xmode_judge_stat.count_by(:"野良", :win) # => 142
Swars::User["SugarHuuko"].stat(sample_max: 200).xmode_judge_stat.exist?(:"指導", :win) # => true
Swars::User["SugarHuuko"].stat(sample_max: 200).xmode_judge_stat.ratio_by(:"野良", :win) # => 0.7135678391959799
Swars::User["SugarHuuko"].stat(sample_max: 200).xmode_judge_stat.count_by(:"指導", :win) # => 1
