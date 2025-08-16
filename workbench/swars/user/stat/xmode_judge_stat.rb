require "./setup"
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_stat.count(:"野良")                    # => 459
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_stat.count(:"指導")                    # => 16
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_judge_stat.counts_hash                 # => {[:指導, :lose] => 8, [:友達, :win] => 350, [:友達, :draw] => 4, [:友達, :lose] => 22, [:野良, :win] => 349, [:指導, :win] => 8, [:野良, :lose] => 109, [:野良, :draw] => 1}
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_judge_stat.count_by(:"野良", :win)     # => 349
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_judge_stat.exist?(:"指導", :win)       # => true
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_judge_stat.ratio_by(:"野良", :win)     # => 0.7603485838779956
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_judge_stat.count_by(:"指導", :win)     # => 8
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_judge_stat.count_by(:"友達", :win)     # => 350
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_judge_stat.count_by(:"友達", :lose)    # => 22
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_judge_stat.ratio_by_xmode_key(:"友達") # => 0.9408602150537635
Swars::User["SugarHuuko"].stat(sample_max: 1000).xmode_judge_stat.friend_kill_ratio * 100     # => 80.2867383512545

Swars::User["slowstep3210"].stat(sample_max: 100).tag_stat.to_win_lose_h(:"大駒全ブッチ") # => {win: 2, lose: 8}
0.5 - (5.0 / (5 + 10))                  # => 0.16666666666666669

Swars::User["BOUYATETSU5"].stat(sample_max: 100).tag_stat.to_win_lose_h(:"大駒全ブッチ") # => {win: 4, lose: 3}
0.5 - (5.0 / (5 + 10))                  # => 0.16666666666666669
