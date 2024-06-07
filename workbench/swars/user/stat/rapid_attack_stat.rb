require "./setup"
Swars::User["SugarHuuko"].stat.win_tag.counts_hash[:"急戦"]   # => 17
Swars::User["SugarHuuko"].stat.win_tag.counts_hash[:"持久戦"] # => 15
Swars::User["SugarHuuko"].stat.ids_count                      # => 50
Swars::User["SugarHuuko"].stat.win_ratio                      # => 0.7
Swars::User["SugarHuuko"].stat.rapid_attack_stat.badge?       # => true
