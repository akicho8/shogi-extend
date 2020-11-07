require "./setup"

file = {io: StringIO.open(Pathname("../../spec/rails.png").read), filename: "foo.png"}
user = User.sysop
avatar = user.avatar
avatar.attach(file)
avatar                                                                        # => #<ActiveStorage::Attached::One:0x00007f85a3ed8520 @name="avatar", @record=#<User id: 1, key: "sysop", name: "運営", cpu_brain_key: nil, user_agent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) Ap...", race_key: "human", created_at: "2020-09-20 09:58:35", updated_at: "2020-10-10 07:27:42", email: "shogi.extend@gmail.com", name_input_at: "2020-09-20 09:58:35", permit_tag_list: nil>>
avatar.attached?                                                              # => true
avatar.saved_changes?      # => false

avatar.saved_change_to_attribute?(:updated_at)       # => false
avatar.saved_change_to_attribute(:updated_at)        # => nil
avatar.attribute_before_last_save(:updated_at)       # => nil
avatar.saved_changes                           # => {}
avatar.saved_changes?                          # => false
avatar.saved_changes.keys                      # => []
avatar.saved_changes.transform_values(&:first) # => {}

user.avatar_attachment.saved_changes?              # => false

user.avatar_blob.saved_changes?              # => true

# User.sysop.avatar_blob.saved_changes? # => false

tp ActiveStorage::Attachment
tp ActiveStorage::Blob

# >> |----+--------+-------------+-----------+---------+---------------------------|
# >> | id | name   | record_type | record_id | blob_id | created_at                |
# >> |----+--------+-------------+-----------+---------+---------------------------|
# >> | 14 | avatar | User        |        10 |      14 | 2020-10-10 16:08:44 +0900 |
# >> | 24 | avatar | User        |         1 |      24 | 2020-10-10 16:27:42 +0900 |
# >> |----+--------+-------------+-----------+---------+---------------------------|
# >> |----+------------------------------+------------+--------------+---------------------------------------------------------------------+-----------+--------------------------+---------------------------|
# >> | id | key                          | filename   | content_type | metadata                                                            | byte_size | checksum                 | created_at                |
# >> |----+------------------------------+------------+--------------+---------------------------------------------------------------------+-----------+--------------------------+---------------------------|
# >> | 14 | c1v92lviqkq9zzvsj3tehr7yl7y3 | avatar.png | image/png    | {"identified"=>true, "width"=>400, "height"=>400, "analyzed"=>true} |    269435 | kdKeA6Xj7wguMYYL3v9k+Q== | 2020-10-10 16:08:44 +0900 |
# >> | 24 | 3kwsj8owcn6cdiztc18thsmkxg7s | foo.png    | image/png    | {"identified"=>true}                                                |      6646 | nAoHm913AdfnKb2VaCPRUw== | 2020-10-10 16:27:42 +0900 |
# >> |----+------------------------------+------------+--------------+---------------------------------------------------------------------+-----------+--------------------------+---------------------------|
