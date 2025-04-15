require "./setup"
# sql
# _ { Swars::User["bsplive"].stat(sample_max: 1500).pro_skill_exceed_stat.count } # =>
# _ { Swars::User["bsplive"].stat(sample_max: 1500).pro_skill_exceed_stat.count } # =>
_ { Swars::User["bsplive"].stat(sample_max: 1500).pro_skill_exceed_stat.count } # => "164.80 ms"
_ { Swars::User["bsplive"].stat(sample_max: 1500).pro_skill_exceed_stat.count } # => "38.41 ms"

# >> {"win"=>1}
# >> {"win"=>1}
