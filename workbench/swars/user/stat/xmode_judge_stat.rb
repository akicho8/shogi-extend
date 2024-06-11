require "./setup"
Swars::User["SugarHuuko"].stat(sample_max: 200).xmode_stat.count(:"野良")                # => 200
Swars::User["SugarHuuko"].stat(sample_max: 200).xmode_stat.count(:"指導")                # => 0
Swars::User["SugarHuuko"].stat(sample_max: 200).xmode_judge_stat.counts_hash             # => {[:野良, :lose]=>49, [:野良, :win]=>147, [:野良, :draw]=>4}
Swars::User["SugarHuuko"].stat(sample_max: 200).xmode_judge_stat.count_by(:"野良", :win) # => 147
Swars::User["SugarHuuko"].stat(sample_max: 200).xmode_judge_stat.exist?(:"指導", :win)   # => false
Swars::User["SugarHuuko"].stat(sample_max: 200).xmode_judge_stat.ratio_by(:"野良", :win) # => 0.735
Swars::User["SugarHuuko"].stat(sample_max: 200).xmode_judge_stat.count_by(:"指導", :win) # => 0
