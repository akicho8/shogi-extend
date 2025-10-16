require "./setup"

judge_final_stat = Swars::User["BOUYATETSU5"].stat(sample_max: 50).judge_final_stat
judge_final_stat.count_by(:win, :ENTERINGKING) # => nil
exit

judge_final_stat = Swars::User["BOUYATETSU5"].stat(sample_max: 1).judge_final_stat
judge_final_stat.count_by(:lose, :TIMEOUT) # => 
judge_final_stat.ratio_by(:lose, :TIMEOUT) # => 
exit

Swars::User["BOUYATETSU5"].stat(sample_max: 200).judge_final_stat.counts_hash            # => 
Swars::User["BOUYATETSU5"].stat(sample_max: 200).judge_final_stat.count_by(:win, :TORYO) # => 
Swars::User["BOUYATETSU5"].stat(sample_max: 200).judge_final_stat.ratio_by(:win, :TORYO) # => 
Swars::User["BOUYATETSU5"].stat(sample_max: 200).judge_final_stat.ratio_by(:lose, :TORYO) # => 
Swars::User["BOUYATETSU5"].stat(sample_max: 200).judge_final_stat.count_by(:lose, :DISCONNECT) # => 
tp Swars::User["BOUYATETSU5"].stat(sample_max: 200).judge_final_stat.counts_hash # => 

s = Swars::User["BOUYATETSU5"].stat(sample_max: 200).ids_scope
s = s.find_all { |e|e.battle.final.key == "DISCONNECT" }
s = s.find_all { |e|e.judge.key == "lose" }
tp s.collect { |e| { judge: e.judge.key, final: e.battle.final.key, key: e.battle.key, turn_max: e.battle.turn_max } }

Swars::Battle.count                       # => 
Swars::Battle.where(:turn_max => 1).count # => 
