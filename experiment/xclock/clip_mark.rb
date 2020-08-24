require "./setup"

tp Xclock::ClipMark
# Xclock::Question.destroy_all

# user = User.sysop
# 
# question1 = user.xclock_questions.create! do |e|
#   e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1"
#   e.moves_answers.build(moves_str: "G*5b")
# end
# question2 = user.xclock_questions.create! do |e|
#   e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l2p 1"
#   e.moves_answers.build(moves_str: "G*5b")
# end
# 
# user.xclock_clip_marks.create!(question: question1) # => #<Xclock::ClipMark id: 32, user_id: 9, question_id: 47, created_at: "2020-06-24 11:24:33", updated_at: "2020-06-24 11:24:33">
# user.xclock_clip_marks.create!(question: question2) # =>
# 
# user.xclock_clip_marks.count      # =>

# >> |----+---------+-------------+---------------------------+---------------------------|
# >> | id | user_id | question_id | created_at                | updated_at                |
# >> |----+---------+-------------+---------------------------+---------------------------|
# >> | 34 |      18 |          71 | 2020-06-24 20:26:09 +0900 | 2020-06-24 20:26:09 +0900 |
# >> | 35 |      18 |          70 | 2020-06-24 20:26:10 +0900 | 2020-06-24 20:26:10 +0900 |
# >> |----+---------+-------------+---------------------------+---------------------------|
