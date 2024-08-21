require "../setup"
black = Swars::User.create!
Swars::Battle.create!(csa_seq: Swars::KifuGenerator.generate_n(14)) do |e|
  e.memberships.build(user: black)
end
Swars::TagJudgeItem.destroy_all
Swars::TagJudgeItem.create_new_generation_items(scope: black.memberships)
Swars::TagJudgeItem.db_latest_items.present? # => true
Swars::TagJudgeItem.db_latest_created_at.present? # => true
Swars::TagJudgeItem.db_latest_generation == 0     # => true
