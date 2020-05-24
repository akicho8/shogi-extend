require "./setup"

Colosseum::User.delete_all

Actb.destroy_all
Actb.setup

user = Colosseum::User.sysop
Actb::Season.newest.generation             # => 1
user.actb_newest_profile.season.generation # => 1
Actb::Season.create!.generation            # => 2
user.actb_newest_profile.season.generation # => 2

tp Actb.info
# >> |-----------------+-------+--------|
# >> | model           | count | 最終ID |
# >> |-----------------+-------+--------|
# >> | Colosseum::User |     1 |     14 |
# >> | Actb::Question  |     0 |        |
# >> | Actb::Battle      |     0 |        |
# >> | Actb::Season    |     2 |      5 |
# >> | Actb::Profile   |     2 |     16 |
# >> | Actb::GoodMark  |     0 |        |
# >> | Actb::BadMark   |     0 |        |
# >> | Actb::ClipMark  |     0 |        |
# >> | Actb::Folder    |     3 |     42 |
# >> |-----------------+-------+--------|
