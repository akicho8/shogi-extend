require "./setup"
_ { Swars::User["bsplive"].stat(sample_max: 1500).draw_stat.positive_rigging_count } # => "215.43 ms"
_ { Swars::User["bsplive"].stat(sample_max: 1500).draw_stat.positive_normal_count  } # => "32.98 ms"
_ { Swars::User["bsplive"].stat(sample_max: 1500).draw_stat.positive_bad_count     } # => "32.04 ms"

Swars::User["bsplive"].stat(sample_max: 1500).draw_stat.positive_rigging_count # => 21
Swars::User["bsplive"].stat(sample_max: 1500).draw_stat.positive_normal_count  # => 17
Swars::User["bsplive"].stat(sample_max: 1500).draw_stat.positive_bad_count     # => 15
