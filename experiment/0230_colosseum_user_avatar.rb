#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
Dir.chdir Rails.root

# ActiveSupport::LogSubscriber.colorize_logging = false
# ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)

ActiveStorage::Attachment.destroy_all

file = "spec/rails.png"

# これはだめ
# file2 = {io: StringIO.new(Base64.encode64(Pathname(file).read)), filename: "foo.png", content_type: "image/png"}

# どの方法でもよい。
file2 = {io: StringIO.open(Pathname(file).read), filename: "foo.png", content_type: "image/png"}
# file2 = {io: File.open(file), filename: "foo.png", content_type: "image/png"}
# file2 = Rack::Test::UploadedFile.new(file, "image/png", :binary)
# file2 = ActionDispatch::Http::UploadedFile.new(filename: File.basename(file), type: "image/png", tempfile: Tempfile.new(file)) # ← セットはできるけど、なぜか variant が失敗する

user = Colosseum::User.create!
# ↓これは user.avatar = file とするのと同じに見えるけど、avatars.attach の場合だと配列でも指定できるのでこっちを使った方がよい
user.avatar.attach(file2)        # => nil
user.avatar                                                                        # => #<ActiveStorage::Attached::One:0x00007f7f58170f50 @name="avatar", @record=#<Colosseum::User id: 27, key: "7eee0b0728a6139d9d041ce9cc3d2826", name: "名無しの棋士18号", online_at: "2018-10-11 03:10:41", fighting_at: nil, matching_at: nil, cpu_brain_key: nil, user_agent: "", race_key: "human", created_at: "2018-10-11 03:10:41", updated_at: "2018-10-11 03:10:41", email: "7eee0b0728a6139d9d041ce9cc3d2826@localhost">, @dependent=:purge_later>
user.avatar.attached?                                                              # => true
user.reload
user.avatar.variant(resize: "32x32", monochrome: true).processed rescue $!         # => #<ActiveStorage::Variant:0x00007f7f5654f178 @blob=#<ActiveStorage::Blob id: 15, key: "c1nhwih8BZw99frDTebyTMPu", filename: "foo.png", content_type: "image/png", metadata: {"identified"=>true}, byte_size: 6646, checksum: "nAoHm913AdfnKb2VaCPRUw==", created_at: "2018-10-11 03:10:41">, @variation=#<ActiveStorage::Variation:0x00007f7f5653f7c8 @transformations={:resize=>"32x32", :monochrome=>true}>>
user.avatar.metadata                                                               # => {"identified"=>true}
user.avatar.content_type                                                               # => "image/png"
user.avatar.image?                                                               # => true
user.avatar.audio?                                                               # => false
user.avatar.video?                                                               # => false
user.avatar.text?                                                               # => false
user.avatar.download.size                                                          # => 6646
Rails.application.routes.url_helpers.rails_blob_path(user.avatar, only_path: true) # => "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBGQT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--34ee7b78962d7501413a48850dcde3ab9e5638ba/foo.png"

Colosseum::User.with_attached_avatar.to_sql # => "SELECT `colosseum_users`.* FROM `colosseum_users`"

tp ActiveStorage::Attachment
tp ActiveStorage::Blob

# 消す
# ActiveStorage::Attachment.count # => 1
# user.avatar.purge               # => nil
# user.avatar.purge               # => nil
# user.avatar.attached?           # => false
# ActiveStorage::Attachment.count # => 0

# >> |----+--------+-----------------+-----------+---------+---------------------------|
# >> | id | name   | record_type     | record_id | blob_id | created_at                |
# >> |----+--------+-----------------+-----------+---------+---------------------------|
# >> | 15 | avatar | Colosseum::User |        27 |      15 | 2018-10-11 12:10:41 +0900 |
# >> |----+--------+-----------------+-----------+---------+---------------------------|
# >> |----+--------------------------+----------+--------------+----------------------+-----------+--------------------------+---------------------------|
# >> | id | key                      | filename | content_type | metadata             | byte_size | checksum                 | created_at                |
# >> |----+--------------------------+----------+--------------+----------------------+-----------+--------------------------+---------------------------|
# >> | 12 | 6UfPjsqhPBx7R1EhnHzxU7wz | foo.png  | image/png    | {"identified"=>true} |      6646 | nAoHm913AdfnKb2VaCPRUw== | 2018-10-10 13:15:22 +0900 |
# >> | 13 | mcXTYfVZrGUekCRgurdtUYDQ | foo.png  | image/png    | {"identified"=>true} |      6646 | nAoHm913AdfnKb2VaCPRUw== | 2018-10-11 12:08:55 +0900 |
# >> | 14 | zasDNjunAFBQmpcP3aYgGRtt | foo.png  | image/png    | {"identified"=>true} |      6646 | nAoHm913AdfnKb2VaCPRUw== | 2018-10-11 12:10:25 +0900 |
# >> | 15 | c1nhwih8BZw99frDTebyTMPu | foo.png  | image/png    | {"identified"=>true} |      6646 | nAoHm913AdfnKb2VaCPRUw== | 2018-10-11 12:10:41 +0900 |
# >> |----+--------------------------+----------+--------------+----------------------+-----------+--------------------------+---------------------------|
