require "./setup"

User.delete_all

Emox.destroy_all
Emox.setup

user1 = User.create!
user2 = User.create!

user1.emox_lobby_messages.create(body: "(body)")

question = user1.emox_questions.create_mock1

room = Emox::Room.create_with_members!([user1, user2])
battle = room.battle_create_with_members!

user1.emox_histories.create!(question: question, ox_mark: Emox::OxMark.fetch(:correct))

user1.emox_good_marks.create!(question: question)
user1.emox_bad_marks.create!(question: question)
user1.emox_clip_marks.create!(question: question)

question.messages.create!(user: user1, body: "(body)")

tp Emox.count_diff { user1.destroy }

# >> |------------------------+--------+-------+------|
# >> | model                  | before | after | diff |
# >> |------------------------+--------+-------+------|
# >> | Emox::Folder           |      6 |     3 |   -3 |
# >> | Emox::Question         |      1 |     0 |   -1 |
# >> | Emox::MovesAnswer      |      1 |     0 |   -1 |
# >> | User                   |      2 |     1 |   -1 |
# >> | Emox::SeasonXrecord    |      2 |     1 |   -1 |
# >> | Emox::MainXrecord      |      2 |     1 |   -1 |
# >> | Emox::Setting          |      2 |     1 |   -1 |
# >> | Emox::GoodMark         |      1 |     0 |   -1 |
# >> | Emox::BadMark          |      1 |     0 |   -1 |
# >> | Emox::ClipMark         |      1 |     0 |   -1 |
# >> | Emox::QuestionMessage  |      1 |     0 |   -1 |
# >> | Emox::LobbyMessage     |      1 |     0 |   -1 |
# >> | Emox::RoomMembership   |      2 |     1 |   -1 |
# >> | Emox::BattleMembership |      2 |     1 |   -1 |
# >> | Emox::RoomMessage      |      0 |     0 |    0 |
# >> | Emox::Room             |      1 |     1 |    0 |
# >> | Emox::Judge            |      4 |     4 |    0 |
# >> | Emox::Battle           |      1 |     1 |    0 |
# >> | Emox::Rule             |     12 |    12 |    0 |
# >> | Emox::Season           |      1 |     1 |    0 |
# >> | Emox::Skill            |     21 |    21 |    0 |
# >> | Emox::Lineage          |      8 |     8 |    0 |
# >> |------------------------+--------+-------+------|
