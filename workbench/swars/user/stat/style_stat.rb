require "./setup"
# Swars::User["bsplive"].stat.style_stat.counts_hash            # => {:準王道=>11, :変態=>7, :準変態=>15, :王道=>4}
# Swars::User["bsplive"].stat.style_stat.ratios_hash            # => {:王道=>0.10810810810810811, :準王道=>0.2972972972972973, :準変態=>0.40540540540540543, :変態=>0.1891891891891892}
# Swars::User["bsplive"].stat.style_stat.denominator            # => 37
# Swars::User["bsplive"].stat.style_stat.majority_ratio         # => 0.40540540540540543
# Swars::User["bsplive"].stat.style_stat.minority_ratio         # => 0.5945945945945946
# Swars::User["bsplive"].stat.style_stat.to_chart               # => [{:name=>"王道", :value=>4}, {:name=>"準王道", :value=>11}, {:name=>"準変態", :value=>15}, {:name=>"変態", :value=>7}]

Swars::User::Stat::StyleStat.vip_update_all(max: 1)

# Swars::User["Jyohshin"].battles.each do |e|
#   p e.id
#   begin
#     e.remake_fast
#   rescue ActiveRecord::Deadlocked => error
#     p error
#   end
# end
# 
# # >> ["/Users/ikeda/src/shogi-extend/app/models/swars/battle/core_methods.rb:64", :parser_exec_after]
