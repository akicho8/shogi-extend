require "../setup"
Swars::User["SugarHuuko"].user_stat.judge_final_stat.counts_hash            # => {["win", "TORYO"]=>27, ["lose", "TORYO"]=>7, ["win", "CHECKMATE"]=>7, ["win", "TIMEOUT"]=>5, ["lose", "TIMEOUT"]=>1, ["draw", "DRAW_SENNICHI"]=>3}
Swars::User["SugarHuuko"].user_stat.judge_final_stat.count_by(:win, :TORYO) # => 27
Swars::User["SugarHuuko"].user_stat.judge_final_stat.ratio_by(:win, :TORYO) # => 0.6923076923076923

