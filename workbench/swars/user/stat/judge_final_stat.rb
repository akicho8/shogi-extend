require "./setup"
Swars::User["BOUYATETSU5"].stat(sample_max: 200).judge_final_stat.counts_hash            # => {[:win, :TORYO]=>108, [:win, :CHECKMATE]=>49, [:win, :TIMEOUT]=>11, [:lose, :TIMEOUT]=>4, [:lose, :CHECKMATE]=>5, [:win, :DISCONNECT]=>2, [:lose, :TORYO]=>14}
Swars::User["BOUYATETSU5"].stat(sample_max: 200).judge_final_stat.count_by(:win, :TORYO) # => 108
Swars::User["BOUYATETSU5"].stat(sample_max: 200).judge_final_stat.ratio_by(:win, :TORYO) # => 0.631578947368421
Swars::User["BOUYATETSU5"].stat(sample_max: 200).judge_final_stat.ratio_by(:lose, :TORYO) # => 0.4827586206896552
Swars::User["BOUYATETSU5"].stat(sample_max: 200).judge_final_stat.count_by(:lose, :DISCONNECT) # => nil
tp Swars::User["BOUYATETSU5"].stat(sample_max: 200).judge_final_stat.counts_hash # => {[:win, :TORYO]=>108, [:win, :CHECKMATE]=>49, [:win, :TIMEOUT]=>11, [:lose, :TIMEOUT]=>4, [:lose, :CHECKMATE]=>5, [:win, :DISCONNECT]=>2, [:lose, :TORYO]=>14}

s = Swars::User["BOUYATETSU5"].stat(sample_max: 200).ids_scope
s = s.find_all{|e|e.battle.final.key == "DISCONNECT"}
s = s.find_all{|e|e.judge.key == "lose"}
tp s.collect{|e| {judge: e.judge.key, final: e.battle.final.key, key: e.battle.key, turn_max: e.battle.turn_max }}

Swars::Battle.where(:turn_max => 1).count # => 5532

# >> |---------------------+-----|
# >> |      [:win, :TORYO] | 108 |
# >> |  [:win, :CHECKMATE] | 49  |
# >> |    [:win, :TIMEOUT] | 11  |
# >> |   [:lose, :TIMEOUT] | 4   |
# >> | [:lose, :CHECKMATE] | 5   |
# >> | [:win, :DISCONNECT] | 2   |
# >> |     [:lose, :TORYO] | 14  |
# >> |---------------------+-----|
# >> |-------+------------+--------------------------------------+----------|
# >> | judge | final      | key                                  | turn_max |
# >> |-------+------------+--------------------------------------+----------|
# >> | lose  | DISCONNECT | Yume48-BOUYATETSU5-20240115_212132   |        1 |
# >> | lose  | DISCONNECT | kazaki2-BOUYATETSU5-20240207_125325  |        1 |
# >> | lose  | DISCONNECT | ky1002-BOUYATETSU5-20240219_094028   |        1 |
# >> | lose  | DISCONNECT | best_cat-BOUYATETSU5-20240219_110655 |        1 |
# >> | lose  | DISCONNECT | micro66-BOUYATETSU5-20240315_104611  |        1 |
# >> | lose  | DISCONNECT | reon_sai-BOUYATETSU5-20240321_105246 |        1 |
# >> |-------+------------+--------------------------------------+----------|
