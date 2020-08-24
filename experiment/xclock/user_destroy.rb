require "./setup"

User.delete_all

Xclock.destroy_all
Xclock.setup

user1 = User.create!
user2 = User.create!

user1.xclock_lobby_messages.create(body: "(body)")

question = user1.xclock_questions.create_mock1

room = Xclock::Room.create_with_members!([user1, user2])
battle = room.battle_create_with_members!

user1.xclock_histories.create!(question: question, ox_mark: Xclock::OxMark.fetch(:correct))

user1.xclock_good_marks.create!(question: question)
user1.xclock_bad_marks.create!(question: question)
user1.xclock_clip_marks.create!(question: question)

question.messages.create!(user: user1, body: "(body)")

tp Xclock.count_diff { user1.destroy }

# >> |------------------------+--------+-------+------|
# >> | model                  | before | after | diff |
# >> |------------------------+--------+-------+------|
# >> | Xclock::Folder           |      6 |     3 |   -3 |
# >> | Xclock::Question         |      1 |     0 |   -1 |
# >> | Xclock::MovesAnswer      |      1 |     0 |   -1 |
# >> | User                   |      2 |     1 |   -1 |
# >> | Xclock::SeasonXrecord    |      2 |     1 |   -1 |
# >> | Xclock::MainXrecord      |      2 |     1 |   -1 |
# >> | Xclock::Setting          |      2 |     1 |   -1 |
# >> | Xclock::GoodMark         |      1 |     0 |   -1 |
# >> | Xclock::BadMark          |      1 |     0 |   -1 |
# >> | Xclock::ClipMark         |      1 |     0 |   -1 |
# >> | Xclock::QuestionMessage  |      1 |     0 |   -1 |
# >> | Xclock::LobbyMessage     |      1 |     0 |   -1 |
# >> | Xclock::RoomMembership   |      2 |     1 |   -1 |
# >> | Xclock::BattleMembership |      2 |     1 |   -1 |
# >> | Xclock::RoomMessage      |      0 |     0 |    0 |
# >> | Xclock::Room             |      1 |     1 |    0 |
# >> | Xclock::Judge            |      4 |     4 |    0 |
# >> | Xclock::Battle           |      1 |     1 |    0 |
# >> | Xclock::Rule             |     12 |    12 |    0 |
# >> | Xclock::Season           |      1 |     1 |    0 |
# >> | Xclock::Skill            |     21 |    21 |    0 |
# >> | Xclock::Lineage          |      8 |     8 |    0 |
# >> |------------------------+--------+-------+------|
