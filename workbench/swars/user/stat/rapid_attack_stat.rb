require "./setup"
Swars::User["SugarHuuko"].stat.tag_stat.win_count_by(:"急戦")      # => 17
Swars::User["SugarHuuko"].stat.tag_stat.win_count_by(:"持久戦")    # => 15
Swars::User["SugarHuuko"].stat.tag_stat.to_win_lose_h(:"持久戦") # => {:win=>15, :lose=>8}
Swars::User["SugarHuuko"].stat.win_stat.exist?(:"持久戦")          # => true
Swars::User["SugarHuuko"].stat.rapid_attack_stat.badge?            # => true
