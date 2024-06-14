require "./setup"
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_stat.count(:"野良")                    # => 945
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_stat.count(:"指導")                    # => 1
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_judge_stat.counts_hash                 # => {[:友達, :win]=>50, [:友達, :draw]=>1, [:友達, :lose]=>3, [:指導, :win]=>1, [:野良, :win]=>620, [:野良, :lose]=>312, [:野良, :draw]=>13}
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_judge_stat.count_by(:"野良", :win)     # => 620
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_judge_stat.exist?(:"指導", :win)       # => true
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_judge_stat.ratio_by(:"野良", :win)     # => 0.656084656084656
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_judge_stat.count_by(:"指導", :win)     # => 1
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_judge_stat.count_by(:"友達", :win)     # => 50
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_judge_stat.count_by(:"友達", :lose)    # => 3
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_judge_stat.ratio_by_xmode_key(:"友達") # => 0.9433962264150944
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_judge_stat.friend_kill_ratio * 100         # => 71.69811320754717

Swars::User["slowstep3210"].stat(sample_max: 100).tag_stat.to_win_lose_h(:"大駒全ブッチ") # => {:win=>2, :lose=>17}
0.5 - (5.0 / (5 + 10))                  # => 0.16666666666666669

Swars::User["BOUYATETSU5"].stat(sample_max: 100).tag_stat.to_win_lose_h(:"大駒全ブッチ") # => {:win=>6, :lose=>0}
0.5 - (5.0 / (5 + 10))                  # => 0.16666666666666669
