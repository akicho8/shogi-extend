require "./setup"

User.delete_all

Wbook.destroy_all
Wbook.setup

user1 = User.create!
user2 = User.create!

user1.wbook_lobby_messages.create(body: "(body)")

question = user1.wbook_questions.create_mock1

room = Wbook::Room.create_with_members!([user1, user2])
battle = room.battle_create_with_members!

user1.wbook_histories.create!(question: question, ox_mark: Wbook::OxMark.fetch(:correct))

user1.wbook_good_marks.create!(question: question)
user1.wbook_bad_marks.create!(question: question)
user1.wbook_clip_marks.create!(question: question)

question.messages.create!(user: user1, body: "(body)")

tp Wbook.count_diff { user1.destroy }

# >> |------------------------+--------+-------+------|
# >> | model                  | before | after | diff |
# >> |------------------------+--------+-------+------|
# >> | Wbook::Folder           |      6 |     3 |   -3 |
# >> | Wbook::Question         |      1 |     0 |   -1 |
# >> | Wbook::MovesAnswer      |      1 |     0 |   -1 |
# >> | User                   |      2 |     1 |   -1 |
# >> | Wbook::SeasonXrecord    |      2 |     1 |   -1 |
# >> | Wbook::MainXrecord      |      2 |     1 |   -1 |
# >> | Wbook::Setting          |      2 |     1 |   -1 |
# >> | Wbook::GoodMark         |      1 |     0 |   -1 |
# >> | Wbook::BadMark          |      1 |     0 |   -1 |
# >> | Wbook::ClipMark         |      1 |     0 |   -1 |
# >> | Wbook::QuestionMessage  |      1 |     0 |   -1 |
# >> | Wbook::LobbyMessage     |      1 |     0 |   -1 |
# >> | Wbook::RoomMembership   |      2 |     1 |   -1 |
# >> | Wbook::BattleMembership |      2 |     1 |   -1 |
# >> | Wbook::RoomMessage      |      0 |     0 |    0 |
# >> | Wbook::Room             |      1 |     1 |    0 |
# >> | Wbook::Judge            |      4 |     4 |    0 |
# >> | Wbook::Battle           |      1 |     1 |    0 |
# >> | Wbook::Rule             |     12 |    12 |    0 |
# >> | Wbook::Season           |      1 |     1 |    0 |
# >> | Wbook::Skill            |     21 |    21 |    0 |
# >> | Wbook::Lineage          |      8 |     8 |    0 |
# >> |------------------------+--------+-------+------|
