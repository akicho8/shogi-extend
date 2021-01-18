require "./setup"

# Wbook::Question.destroy_all
# user1 = User.create!
# question1 = user1.wbook_questions.create_mock1
# tp question1.moves_answers
# exit


question1 = Wbook::Question.first
question1.reload
question1.reload

tp question1.save!

Wbook::Question.find_each do |e|
  e.moves_answers.each do |e|
    e.send(:attribute_will_change!, :moves_str)
    e.save!(touch: false)
  end
end

tp question1.moves_answers
# >> |------|
# >> | true |
# >> |------|
# >> |-------------+----+-----------+-------------+-----------------+----------+---------------------------+---------------------------|
# >> | question_id | id | moves_str | moves_count | moves_human_str | end_sfen | created_at                | updated_at                |
# >> |-------------+----+-----------+-------------+-----------------+----------+---------------------------+---------------------------|
# >> |          44 | 47 | G*5b      |           1 | ▲52金打        |          | 2020-07-29 13:34:13 +0900 | 2020-07-29 13:38:26 +0900 |
# >> |-------------+----+-----------+-------------+-----------------+----------+---------------------------+---------------------------|
