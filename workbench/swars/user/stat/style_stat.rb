require "./setup"
Swars::User["bsplive"].stat.style_stat.tactic_count_pair_list # => [[<中原流急戦矢倉>, 1], [<矢倉中飛車>, 1], [<右四間飛車>, 3], [<かまいたち戦法>, 11], [<高田流左玉>, 1], [<角交換型>, 1], [<角換わり>, 1], [<手得角交換型>, 1], [<手損角交換型>, 1], [<相掛かり>, 1], [<向かい飛車>, 7], [<相振り飛車>, 11], [<銀雲雀>, 1], [<ショーダンオリジナル>, 4], [<対振り持久戦>, 2], [<カメレオン戦法>, 1], [<力戦>, 12], [<居玉>, 10], [<カニ囲い>, 14], [<カタ囲い>, 1], [<オールド雁木>, 2], [<居飛車金美濃>, 1], [<舟囲い>, 1], [<ミレニアム囲い>, 1]]
Swars::User["bsplive"].stat.style_stat.counts_hash            # => {:rarity_key_SSR=>8, :rarity_key_SR=>16, :rarity_key_R=>16, :rarity_key_N=>17}
Swars::User["bsplive"].stat.style_stat.ratios_hash            # => {:rarity_key_SSR=>0.14035087719298245, :rarity_key_SR=>0.2807017543859649, :rarity_key_R=>0.2807017543859649, :rarity_key_N=>0.2982456140350877}
Swars::User["bsplive"].stat.style_stat.denominator            # => 57
Swars::User["bsplive"].stat.style_stat.majority_ratio         # => 0.5789473684210527
Swars::User["bsplive"].stat.style_stat.minority_ratio         # => 0.42105263157894735
Swars::User["bsplive"].stat.style_stat.to_chart               # => [{:name=>"王道", :value=>17}, {:name=>"準王道", :value=>16}, {:name=>"準変態", :value=>16}, {:name=>"変態", :value=>8}]
