require "./setup"

User.delete_all

Actb.destroy_all
Actb.setup

user1 = User.create!
user2 = User.create!

user1.actb_lobby_messages.create(body: "(body)")

question = user1.actb_questions.create_mock1

room = Actb::Room.create_with_members!([user1, user2])
battle = room.battle_create_with_members!

membership = battle.memberships.first

membership.user.actb_histories.create!(membership: membership, question: question, ox_mark: Actb::OxMark.fetch(:correct))

user1.actb_good_marks.create!(question: question)
user1.actb_bad_marks.create!(question: question)
user1.actb_clip_marks.create!(question: question)

question.messages.create!(user: user1, body: "(body)")

tp Actb.count_diff { user1.destroy }

# >> |------------------------+--------+-------+------|
# >> | model                  | before | after | diff |
# >> |------------------------+--------+-------+------|
# >> | Actb::Folder           |      6 |     3 |   -3 |
# >> | Actb::Question         |      1 |     0 |   -1 |
# >> | Actb::MovesAnswer      |      1 |     0 |   -1 |
# >> | User                   |      2 |     1 |   -1 |
# >> | Actb::RoomMembership   |      2 |     1 |   -1 |
# >> | Actb::BattleMembership |      2 |     1 |   -1 |
# >> | Actb::SeasonXrecord    |      2 |     1 |   -1 |
# >> | Actb::MainXrecord      |      2 |     1 |   -1 |
# >> | Actb::Setting          |      2 |     1 |   -1 |
# >> | Actb::GoodMark         |      1 |     0 |   -1 |
# >> | Actb::BadMark          |      1 |     0 |   -1 |
# >> | Actb::ClipMark         |      1 |     0 |   -1 |
# >> | Actb::QuestionMessage  |      1 |     0 |   -1 |
# >> | Actb::Rule             |     12 |    12 |    0 |
# >> | Actb::Room             |      1 |     1 |    0 |
# >> | Actb::Skill            |     21 |    21 |    0 |
# >> | Actb::Battle           |      1 |     1 |    0 |
# >> | Actb::RoomMessage      |      0 |     0 |    0 |
# >> | Actb::Season           |      1 |     1 |    0 |
# >> | Actb::LobbyMessage     |      1 |     1 |    0 |
# >> | Actb::Judge            |      4 |     4 |    0 |
# >> | Actb::Lineage          |      8 |     8 |    0 |
# >> |------------------------+--------+-------+------|
