require "./setup"
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_stat.count(:"野良")                    # => 979
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_stat.count(:"指導")                    # => 1
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_judge_stat.counts_hash                 # => {[:野良, :win]=>634, [:野良, :lose]=>332, [:野良, :draw]=>13, [:友達, :win]=>16, [:友達, :lose]=>3, [:友達, :draw]=>1, [:指導, :win]=>1}
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_judge_stat.count_by(:"野良", :win)     # => 634
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_judge_stat.exist?(:"指導", :win)       # => true
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_judge_stat.ratio_by(:"野良", :win)     # => 0.6475995914198162
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_judge_stat.count_by(:"指導", :win)     # => 1
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_judge_stat.count_by(:"友達", :win)     # => 16
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_judge_stat.count_by(:"友達", :lose)    # => 3
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_judge_stat.ratio_by_xmode_key(:"友達") # => 0.8421052631578947
