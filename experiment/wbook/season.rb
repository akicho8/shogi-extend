require "./setup"

User.delete_all

Wbook.destroy_all
Wbook.setup

user = User.sysop
user.rating            # => 0.15e4
user.wbook_main_xrecord.update!(rating: 1501) 
user.rating            # => 0.1501e4
Wbook::Season.create!
user.wbook_latest_xrecord.rating # => 0.1501e4

tp Wbook.info
# >> load: /Users/ikeda/src/shogi_web/app/models/wbook/questions.yml
# >> |------------------------+-------+--------|
# >> | model                  | count | 最終ID |
# >> |------------------------+-------+--------|
# >> | User                   |     1 |     65 |
# >> | Wbook::Question         |     6 |    120 |
# >> | Wbook::QuestionMessage  |     0 |        |
# >> | Wbook::Room             |     0 |        |
# >> | Wbook::RoomMembership   |     0 |        |
# >> | Wbook::RoomMessage      |     0 |        |
# >> | Wbook::Battle           |     0 |        |
# >> | Wbook::BattleMembership |     0 |        |
# >> | Wbook::Season           |     2 |     73 |
# >> | Wbook::SeasonXrecord    |     2 |     75 |
# >> | Wbook::Setting          |     1 |     65 |
# >> | Wbook::GoodMark         |     0 |        |
# >> | Wbook::BadMark          |     0 |        |
# >> | Wbook::ClipMark         |     0 |        |
# >> | Wbook::Folder           |     3 |    195 |
# >> | Wbook::Lineage          |     7 |     70 |
# >> | Wbook::Judge            |     4 |     40 |
# >> | Wbook::Rule             |     3 |     30 |
# >> | Wbook::Skill           |    21 |    210 |
# >> | Wbook::LobbyMessage     |     0 |        |
# >> |------------------------+-------+--------|
