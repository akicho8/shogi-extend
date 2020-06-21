require "./setup"

file = {io: StringIO.open(Pathname("../../spec/rails.png").read), filename: "foo.png"}
user = User.sysop
user.avatar.attach(file)
user.avatar                                                                        # => #<ActiveStorage::Attached::One:0x00007fa54b9bd6b8 @name="avatar", @record=#<User id: 14, key: "sysop", name: "運営", online_at: nil, fighting_at: nil, matching_at: nil, cpu_brain_key: nil, user_agent: "", race_key: "human", created_at: "2020-05-25 14:20:35", updated_at: "2020-05-28 05:44:05", email: "sysop@localhost", joined_at: "2020-05-25 14:20:35">>
user.avatar.attached?                                                              # => true

tp ActiveStorage::Attachment
tp ActiveStorage::Blob

# >> |----+--------+-----------------+-----------+---------+---------------------------|
# >> | id | name   | record_type     | record_id | blob_id | created_at                |
# >> |----+--------+-----------------+-----------+---------+---------------------------|
# >> | 11 | avatar | User |        14 |      11 | 2020-05-28 14:44:05 +0900 |
# >> |----+--------+-----------------+-----------+---------+---------------------------|
# >> |----+------------------------------+----------+--------------+-------------------------------------------------------------------+-----------+--------------------------+---------------------------|
# >> | id | key                          | filename | content_type | metadata                                                          | byte_size | checksum                 | created_at                |
# >> |----+------------------------------+----------+--------------+-------------------------------------------------------------------+-----------+--------------------------+---------------------------|
# >> | 10 | 8cojyvbhi5w7ue46rb3d2jfdgpq4 | foo.png  | image/png    | {"identified"=>true, "width"=>50, "height"=>64, "analyzed"=>true} |      6646 | nAoHm913AdfnKb2VaCPRUw== | 2020-05-28 14:44:00 +0900 |
# >> | 11 | u8r2mf39yc4ba8vzl6k62501xrdj | foo.png  | image/png    | {"identified"=>true}                                              |      6646 | nAoHm913AdfnKb2VaCPRUw== | 2020-05-28 14:44:05 +0900 |
# >> |----+------------------------------+----------+--------------+-------------------------------------------------------------------+-----------+--------------------------+---------------------------|
