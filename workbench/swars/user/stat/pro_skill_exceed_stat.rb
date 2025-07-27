require "./setup"
# sql
# _ { Swars::User["bsplive"].stat(sample_max: 1500).pro_skill_exceed_stat.count } # =>
# _ { Swars::User["bsplive"].stat(sample_max: 1500).pro_skill_exceed_stat.count } # =>
# _ { Swars::User["bsplive"].stat(sample_max: 1500).pro_skill_exceed_stat.count } # =>
# _ { Swars::User["bsplive"].stat(sample_max: 1500).pro_skill_exceed_stat.count } # =>

# Swars::User["bsplive"].stat(sample_max: 1500).pro_skill_exceed_stat.counts_hash # =>

black = Swars::User.create!
white = Swars::User.create!(grade_key: "十段")
Swars::Battle.create!(xmode_key: "指導", preset_key: "角落") do |e|
  e.memberships.build(user: black, judge_key: :win)
  e.memberships.build(user: white)
end
p black.stat.pro_skill_exceed_stat.counts_hash

# >> #<ActiveRecord::Relation []>
# >> {}
