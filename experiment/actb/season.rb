require "./setup"

User.delete_all

Actb.destroy_all
Actb.setup

user = User.sysop
user.rating            # => 0.15e4
user.actb_main_xrecord.update!(rating: 1501) 
user.rating            # => 0.1501e4
Actb::Season.create!
user.actb_latest_xrecord.rating # => 0.1501e4

tp Actb.info
# >> load: /Users/ikeda/src/shogi_web/app/models/actb/questions.yml
# >> |------------------------+-------+--------|
# >> | model                  | count | 最終ID |
# >> |------------------------+-------+--------|
# >> | User                   |     1 |     65 |
# >> | Actb::Question         |     6 |    120 |
# >> | Actb::QuestionMessage  |     0 |        |
# >> | Actb::Room             |     0 |        |
# >> | Actb::RoomMembership   |     0 |        |
# >> | Actb::RoomMessage      |     0 |        |
# >> | Actb::Battle           |     0 |        |
# >> | Actb::BattleMembership |     0 |        |
# >> | Actb::Season           |     2 |     73 |
# >> | Actb::SeasonXrecord    |     2 |     75 |
# >> | Actb::Setting          |     1 |     65 |
# >> | Actb::GoodMark         |     0 |        |
# >> | Actb::BadMark          |     0 |        |
# >> | Actb::ClipMark         |     0 |        |
# >> | Actb::Folder           |     3 |    195 |
# >> | Actb::Lineage          |     7 |     70 |
# >> | Actb::Judge            |     4 |     40 |
# >> | Actb::Rule             |     3 |     30 |
# >> | Actb::Skill           |    21 |    210 |
# >> | Actb::LobbyMessage     |     0 |        |
# >> |------------------------+-------+--------|
