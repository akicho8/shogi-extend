require "./setup"

User.delete_all

Wkbk.destroy_all
Wkbk.setup

user1 = User.create!
user2 = User.create!

user1.wkbk_lobby_messages.create(body: "(body)")

question = user1.wkbk_questions.create_mock1

room = Wkbk::Room.create_with_members!([user1, user2])
battle = room.battle_create_with_members!

user1.wkbk_histories.create!(question: question, ox_mark: Wkbk::OxMark.fetch(:correct))

user1.wkbk_good_marks.create!(question: question)
user1.wkbk_bad_marks.create!(question: question)
user1.wkbk_clip_marks.create!(question: question)

question.messages.create!(user: user1, body: "(body)")

tp Wkbk.count_diff { user1.destroy }

# >> |------------------------+--------+-------+------|
# >> | model                  | before | after | diff |
# >> |------------------------+--------+-------+------|
# >> | Wkbk::Folder           |      6 |     3 |   -3 |
# >> | Wkbk::Question         |      1 |     0 |   -1 |
# >> | Wkbk::MovesAnswer      |      1 |     0 |   -1 |
# >> | User                   |      2 |     1 |   -1 |
# >> | Wkbk::SeasonXrecord    |      2 |     1 |   -1 |
# >> | Wkbk::MainXrecord      |      2 |     1 |   -1 |
# >> | Wkbk::Setting          |      2 |     1 |   -1 |
# >> | Wkbk::GoodMark         |      1 |     0 |   -1 |
# >> | Wkbk::BadMark          |      1 |     0 |   -1 |
# >> | Wkbk::ClipMark         |      1 |     0 |   -1 |
# >> | Wkbk::QuestionMessage  |      1 |     0 |   -1 |
# >> | Wkbk::LobbyMessage     |      1 |     0 |   -1 |
# >> | Wkbk::RoomMembership   |      2 |     1 |   -1 |
# >> | Wkbk::BattleMembership |      2 |     1 |   -1 |
# >> | Wkbk::RoomMessage      |      0 |     0 |    0 |
# >> | Wkbk::Room             |      1 |     1 |    0 |
# >> | Wkbk::Judge            |      4 |     4 |    0 |
# >> | Wkbk::Battle           |      1 |     1 |    0 |
# >> | Wkbk::Rule             |     12 |    12 |    0 |
# >> | Wkbk::Season           |      1 |     1 |    0 |
# >> | Wkbk::Skill            |     21 |    21 |    0 |
# >> | Wkbk::Lineage          |      8 |     8 |    0 |
# >> |------------------------+--------+-------+------|
