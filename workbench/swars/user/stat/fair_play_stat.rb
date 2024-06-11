require "./setup"
# _ { Swars::User["bsplive"].stat(sample_max: 200).fair_play_stat.positive_rigging_count } # => "215.43 ms"
# _ { Swars::User["bsplive"].stat(sample_max: 200).fair_play_stat.positive_normal_count  } # => "32.98 ms"
# _ { Swars::User["bsplive"].stat(sample_max: 200).fair_play_stat.positive_bad_count     } # => "32.04 ms"
# 
# Swars::User["bsplive"].stat(sample_max: 200).fair_play_stat.positive_rigging_count # => 21
# Swars::User["bsplive"].stat(sample_max: 200).fair_play_stat.positive_normal_count  # => 17
# Swars::User["bsplive"].stat(sample_max: 200).fair_play_stat.positive_bad_count     # => 15

Swars::User["bsplive"].stat(sample_max: 200).fair_play_stat.score # => 7
Swars::User["bsplive"].stat(sample_max: 200).fair_play_stat.send(:score_max) # => 17
Swars::User["bsplive"].stat(sample_max: 200).fair_play_stat.percentage_score # => 41
tp Swars::User["bsplive"].stat(sample_max: 200).fair_play_stat.to_a
# >> |--------+------------------------------------------+------|
# >> | スコア | 項目                                     | 結果 |
# >> |--------+------------------------------------------+------|
# >> |      3 | 必敗ならすべて投了した                   |      |
# >> |      2 | 無理攻めをしていない                     |    2 |
# >> |      2 | 負けそうになってもすぐに投げない         |    2 |
# >> |      2 | 対局放棄のような長考をしない             |    2 |
# >> |      1 | 舐めプをしていない                       |    1 |
# >> |      1 | 無気力な対局をしていない                 |      |
# >> |      1 | 1手詰を焦らしていない                    |      |
# >> |      1 | 放置していない                           |      |
# >> |      1 | 人に対して棋神を使わない                 |      |
# >> |      1 | ギリギリまで放置して逆転狙いをしていない |      |
# >> |      1 | 切断していない                           |      |
# >> |      1 | 適正な相手と対局している                 |      |
# >> |--------+------------------------------------------+------|
