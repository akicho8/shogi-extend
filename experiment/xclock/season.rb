require "./setup"

User.delete_all

Xclock.destroy_all
Xclock.setup

user = User.sysop
user.rating            # => 0.15e4
user.xclock_main_xrecord.update!(rating: 1501) 
user.rating            # => 0.1501e4
Xclock::Season.create!
user.xclock_latest_xrecord.rating # => 0.1501e4

tp Xclock.info
# >> load: /Users/ikeda/src/shogi_web/app/models/xclock/questions.yml
# >> |------------------------+-------+--------|
# >> | model                  | count | 最終ID |
# >> |------------------------+-------+--------|
# >> | User                   |     1 |     65 |
# >> | Xclock::Question         |     6 |    120 |
# >> | Xclock::QuestionMessage  |     0 |        |
# >> | Xclock::Room             |     0 |        |
# >> | Xclock::RoomMembership   |     0 |        |
# >> | Xclock::RoomMessage      |     0 |        |
# >> | Xclock::Battle           |     0 |        |
# >> | Xclock::BattleMembership |     0 |        |
# >> | Xclock::Season           |     2 |     73 |
# >> | Xclock::SeasonXrecord    |     2 |     75 |
# >> | Xclock::Setting          |     1 |     65 |
# >> | Xclock::GoodMark         |     0 |        |
# >> | Xclock::BadMark          |     0 |        |
# >> | Xclock::ClipMark         |     0 |        |
# >> | Xclock::Folder           |     3 |    195 |
# >> | Xclock::Lineage          |     7 |     70 |
# >> | Xclock::Judge            |     4 |     40 |
# >> | Xclock::Rule             |     3 |     30 |
# >> | Xclock::Skill           |    21 |    210 |
# >> | Xclock::LobbyMessage     |     0 |        |
# >> |------------------------+-------+--------|
