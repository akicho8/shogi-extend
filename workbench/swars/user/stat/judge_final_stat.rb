require "./setup"
Swars::User["SugarHuuko"].stat.judge_final_stat.counts_hash            # => {["win", "TORYO"]=>20, ["win", "CHECKMATE"]=>6, ["win", "TIMEOUT"]=>9, ["lose", "TORYO"]=>15}
Swars::User["SugarHuuko"].stat.judge_final_stat.count_by(:win, :TORYO) # => 20
Swars::User["SugarHuuko"].stat.judge_final_stat.ratio_by(:win, :TORYO) # => 0.5714285714285714
Swars::User["SugarHuuko"].stat.judge_final_stat.ratio_by(:lose, :TORYO) # => 1.0

