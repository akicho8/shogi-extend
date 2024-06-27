require "./setup"
Swars::User["bsplive"].stat.style_stat_mod.tactic_count_pair_list # => [[<中原流急戦矢倉>, 1], [<矢倉中飛車>, 1], [<右四間飛車>, 3], [<かまいたち戦法>, 11], [<高田流左玉>, 1], [<角交換型>, 1], [<角換わり>, 1], [<手得角交換型>, 1], [<手損角交換型>, 1], [<相掛かり>, 1], [<向かい飛車>, 7], [<銀雲雀>, 1], [<ショーダンオリジナル>, 4], [<対振り持久戦>, 2], [<カメレオン戦法>, 1], [<力戦>, 12], [<居玉>, 10], [<カニ囲い>, 14], [<カタ囲い>, 1], [<オールド雁木>, 2], [<居飛車金美濃>, 1], [<舟囲い>, 1], [<ミレニアム囲い>, 1]]
Swars::User["bsplive"].stat.style_stat_mod.counts_hash            # => {:王道=>8, :準王道=>16, :準変態=>16, :変態=>17}
Swars::User["bsplive"].stat.style_stat_mod.ratios_hash            # => {:王道=>0.14035087719298245, :準王道=>0.2807017543859649, :準変態=>0.2807017543859649, :変態=>0.2982456140350877}
Swars::User["bsplive"].stat.style_stat_mod.denominator            # => 57
Swars::User["bsplive"].stat.style_stat_mod.majority_ratio         # => 0.42105263157894735
Swars::User["bsplive"].stat.style_stat_mod.minority_ratio         # => 0.5789473684210527
Swars::User["bsplive"].stat.style_stat_mod.to_chart               # => [{:name=>"王道", :value=>8}, {:name=>"準王道", :value=>16}, {:name=>"準変態", :value=>16}, {:name=>"変態", :value=>17}]
