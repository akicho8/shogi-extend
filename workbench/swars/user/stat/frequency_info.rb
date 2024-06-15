require "../setup"
Swars::User::Stat::FrequencyInfo.collect(&:two_char_key) # => ["P1", "S1", "R1", "G1", "B1", "K1", "N1", "L1", "B0", "R0", "P0", "S0", "N0", "L0"]
