require "./setup"
Swars::User["bsplive"].stat.style_stat.counts_hash            # => {:王道=>28, :準王道=>15, :準変態=>6}
Swars::User["bsplive"].stat.style_stat.ratios_hash            # => {:王道=>0.5714285714285714, :準王道=>0.30612244897959184, :準変態=>0.12244897959183673, :変態=>0.0}
Swars::User["bsplive"].stat.style_stat.denominator            # => 49
Swars::User["bsplive"].stat.style_stat.majority_ratio         # => 0.8775510204081632
Swars::User["bsplive"].stat.style_stat.minority_ratio         # => 0.12244897959183673
Swars::User["bsplive"].stat.style_stat.to_chart               # => [{:name=>"王道", :value=>28}, {:name=>"準王道", :value=>15}, {:name=>"準変態", :value=>6}, {:name=>"変態", :value=>0}]
# Swars::User::Stat::StyleStat.vip_update_all(max: 1)
