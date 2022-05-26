require "./setup"

User.delete_all

Emox.destroy_all
Emox.setup

user = User.sysop
user.rating            # => 0.15e4
user.emox_main_xrecord.update!(rating: 1501) 
user.rating            # => 0.1501e4
Emox::Season.create!
user.emox_latest_xrecord.rating # => 0.1501e4

tp Emox.info
# >> load: /Users/ikeda/src/shogi_web/app/models/emox/questions.yml
# >> |------------------------+-------+--------|
# >> | model                  | count | 最終ID |
# >> |------------------------+-------+--------|
# >> | User                   |     1 |     65 |
# >> | Emox::Question         |     6 |    120 |
# >> | Emox::QuestionMessage  |     0 |        |
# >> | Emox::Room             |     0 |        |
# >> | Emox::RoomMembership   |     0 |        |
# >> | Emox::RoomMessage      |     0 |        |
# >> | Emox::Battle           |     0 |        |
# >> | Emox::BattleMembership |     0 |        |
# >> | Emox::Season           |     2 |     73 |
# >> | Emox::SeasonXrecord    |     2 |     75 |
# >> | Emox::Setting          |     1 |     65 |
# >> | Emox::GoodMark         |     0 |        |
# >> | Emox::BadMark          |     0 |        |
# >> | Emox::ClipMark         |     0 |        |
# >> | Emox::Folder           |     3 |    195 |
# >> | Emox::Lineage          |     7 |     70 |
# >> | Emox::Judge            |     4 |     40 |
# >> | Emox::Rule             |     3 |     30 |
# >> | Emox::Skill           |    21 |    210 |
# >> | Emox::LobbyMessage     |     0 |        |
# >> |------------------------+-------+--------|
