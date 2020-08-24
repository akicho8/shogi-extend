require "./setup"

Xclock::Question.destroy_all

user1 = User.create!
user2 = User.create!

question1 = user1.xclock_questions.create_mock1

user2.xclock_good_marks.create!(question: question1)
user2.xclock_good_marks.count     # => 1

user1.xclock_good_marks.create!(question: question1)
user1.xclock_good_marks.count     # => 1

user2.xclock_bad_marks.create!(question: question1)
user2.xclock_bad_marks.count     # => 1

user1.xclock_bad_marks.create!(question: question1)
user1.xclock_bad_marks.count     # => 1

question1.good_marks_count      # => 2
question1.bad_marks_count      # => 2

tp question1.good_marks
tp question1.bad_marks

# Xclock::Question.find_each do |e|
#   e.good_marks.where(user: e.user).destroy_all
#   e.bad_marks.where(user: e.user).destroy_all
# end
Xclock::Question.good_bad_click_by_owner_reject_all

question1.reload
tp question1.good_marks
tp question1.bad_marks
# >> |----+---------+-------------+---------------------------+---------------------------|
# >> | id | user_id | question_id | created_at                | updated_at                |
# >> |----+---------+-------------+---------------------------+---------------------------|
# >> | 33 |      44 |          30 | 2020-07-25 11:20:48 +0900 | 2020-07-25 11:20:48 +0900 |
# >> | 34 |      43 |          30 | 2020-07-25 11:20:48 +0900 | 2020-07-25 11:20:48 +0900 |
# >> |----+---------+-------------+---------------------------+---------------------------|
# >> |----+---------+-------------+---------------------------+---------------------------|
# >> | id | user_id | question_id | created_at                | updated_at                |
# >> |----+---------+-------------+---------------------------+---------------------------|
# >> | 15 |      44 |          30 | 2020-07-25 11:20:48 +0900 | 2020-07-25 11:20:48 +0900 |
# >> | 16 |      43 |          30 | 2020-07-25 11:20:48 +0900 | 2020-07-25 11:20:48 +0900 |
# >> |----+---------+-------------+---------------------------+---------------------------|
# >> [2, 2]
# >> [1, 1]
# >> |----+---------+-------------+---------------------------+---------------------------|
# >> | id | user_id | question_id | created_at                | updated_at                |
# >> |----+---------+-------------+---------------------------+---------------------------|
# >> | 33 |      44 |          30 | 2020-07-25 11:20:48 +0900 | 2020-07-25 11:20:48 +0900 |
# >> |----+---------+-------------+---------------------------+---------------------------|
# >> |----+---------+-------------+---------------------------+---------------------------|
# >> | id | user_id | question_id | created_at                | updated_at                |
# >> |----+---------+-------------+---------------------------+---------------------------|
# >> | 15 |      44 |          30 | 2020-07-25 11:20:48 +0900 | 2020-07-25 11:20:48 +0900 |
# >> |----+---------+-------------+---------------------------+---------------------------|
