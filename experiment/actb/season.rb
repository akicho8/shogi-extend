require "./setup"

Colosseum::User.delete_all

Actb.destroy_all
Actb.setup

user = Colosseum::User.sysop
user.rating            # => 1500
user.actb_master_xrecord.update!(rating: 1501) 
user.rating            # => 1501
Actb::Season.create!
user.actb_current_xrecord.rating # => 1501

tp Actb.info
# >> |------------------------+-------+--------|
# >> | model                  | count | 最終ID |
# >> |------------------------+-------+--------|
# >> | Colosseum::User        |     1 |     55 |
# >> | Actb::Question         |     0 |        |
# >> | Actb::QuestionMessage  |     0 |        |
# >> | Actb::Room             |     0 |        |
# >> | Actb::RoomMembership   |     0 |        |
# >> | Actb::RoomMessage      |     0 |        |
# >> | Actb::Battle           |     0 |        |
# >> | Actb::BattleMembership |     0 |        |
# >> | Actb::Season           |     2 |     51 |
# >> | Actb::SeasonXrecord    |     2 |     69 |
# >> | Actb::Setting          |     1 |     55 |
# >> | Actb::GoodMark         |     0 |        |
# >> | Actb::BadMark          |     0 |        |
# >> | Actb::ClipMark         |     0 |        |
# >> | Actb::Folder           |     3 |    165 |
# >> | Actb::Lineage          |     7 |    119 |
# >> | Actb::Judge            |     4 |     68 |
# >> | Actb::LobbyMessage     |     0 |        |
# >> |------------------------+-------+--------|
