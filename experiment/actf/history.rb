require "./setup"

Actf.destroy_all

user = Colosseum::User.sysop

question = user.actf_questions.create! do |e|
  e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1"
  e.moves_answers.build(moves_str: "G*5b")
end

user2 = Colosseum::User.create!

room = Actf::Room.create! do |e|
  e.memberships.build(user: user)
  e.memberships.build(user: user2)
end

membership = room.memberships.first

history = user.actf_histories.create!(membership: membership, question: question, ans_result: Actf::AnsResult.fetch(:correct))
tp history

# >> |---------------+---------------------------|
# >> |            id | 3                         |
# >> | membership_id | 3                         |
# >> |   question_id | 2                         |
# >> | ans_result_id | 1                         |
# >> |    created_at | 2020-05-14 15:22:19 +0900 |
# >> |    updated_at | 2020-05-14 15:22:19 +0900 |
# >> |       room_id | 2                         |
# >> |       user_id | 1                         |
# >> |---------------+---------------------------|
