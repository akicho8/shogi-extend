require "./setup"

User.delete_all

Wkbk.destroy_all
Wkbk.setup

user = User.sysop
user.rating            # => 0.15e4
user.wkbk_main_xrecord.update!(rating: 1501) 
user.rating            # => 0.1501e4
Wkbk::Season.create!
user.wkbk_latest_xrecord.rating # => 0.1501e4

tp Wkbk.info
# >> load: /Users/ikeda/src/shogi_web/app/models/wkbk/questions.yml
# >> |------------------------+-------+--------|
# >> | model                  | count | 最終ID |
# >> |------------------------+-------+--------|
# >> | User                   |     1 |     65 |
# >> | Wkbk::Question         |     6 |    120 |
# >> | Wkbk::QuestionMessage  |     0 |        |
# >> | Wkbk::Room             |     0 |        |
# >> | Wkbk::RoomMembership   |     0 |        |
# >> | Wkbk::RoomMessage      |     0 |        |
# >> | Wkbk::Battle           |     0 |        |
# >> | Wkbk::BattleMembership |     0 |        |
# >> | Wkbk::Season           |     2 |     73 |
# >> | Wkbk::SeasonXrecord    |     2 |     75 |
# >> | Wkbk::Setting          |     1 |     65 |
# >> | Wkbk::GoodMark         |     0 |        |
# >> | Wkbk::BadMark          |     0 |        |
# >> | Wkbk::ClipMark         |     0 |        |
# >> | Wkbk::Folder           |     3 |    195 |
# >> | Wkbk::Lineage          |     7 |     70 |
# >> | Wkbk::Judge            |     4 |     40 |
# >> | Wkbk::Rule             |     3 |     30 |
# >> | Wkbk::Skill           |    21 |    210 |
# >> | Wkbk::LobbyMessage     |     0 |        |
# >> |------------------------+-------+--------|
