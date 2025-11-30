#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
Dir.chdir Rails.root

# ActiveSupport::LogSubscriber.colorize_logging = false
# ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)

ActiveStorage::Attachment.destroy_all
ActiveStorage::Blob.destroy_all

file = "spec/rails.png"

# これはだめ
# file2 = {io: StringIO.new(Base64.encode64(Pathname(file).read)), filename: "foo.png", content_type: "image/png"}

# どの方法でもよい。
file2 = { io: StringIO.open(Pathname(file).read), filename: "foo.png" }
# file2 = {io: StringIO.open(Pathname(file).read), filename: "foo.png"} # content_type はなくてもいい。, content_type: "image/png"
# file2 = {io: File.open(file), filename: "foo.png", content_type: "image/png"}
# file2 = Rack::Test::UploadedFile.new(file, "image/png", :binary)
# file2 = ActionDispatch::Http::UploadedFile.new(filename: File.basename(file), type: "image/png", tempfile: Tempfile.new(file)) # ← セットはできるけど、なぜか variant が失敗する

user = User.create!
# ↓これは user.avatar = file とするのと同じに見えるけど、avatars.attach の場合だと配列でも指定できるのでこっちを使った方がよい
user.avatar.attach(file2) # => true
user.avatar               # => #<ActiveStorage::Attached::One:0x00007f85e6af0258 @name="avatar", @record=#<User id: 11, key: "916ed5b32e5f1645c55e1b26b551a831", name: "名無しの棋士2号", online_at: nil, fighting_at: nil, matching_at: nil, cpu_brain_key: nil, user_agent: "", race_key: "human", created_at: "2020-06-05 13:21:16", updated_at: "2020-06-05 13:21:16", email: "916ed5b32e5f1645c55e1b26b551a831@localhost", joined_at: "2020-06-05 13:21:16">>
user.avatar.attached?     # => true
user.reload
user.avatar.variant(resize: "32x32", monochrome: true).processed rescue $!         # => #<ActiveStorage::Variant:0x00007f85e6d32c00 @blob=#<ActiveStorage::Blob id: 1, key: "gfob36v4oxgl0b3c15omqwzlmz84", filename: "foo.png", content_type: "image/png", metadata: {"identified"=>true}, byte_size: 6646, checksum: "nAoHm913AdfnKb2VaCPRUw==", created_at: "2020-06-05 13:21:16">, @variation=#<ActiveStorage::Variation:0x00007f85e6d39370 @transformations={:resize=>"32x32", :monochrome=>true}>, @specification=#<ActiveStorage::Variant::Specification filename=#<ActiveStorage::Filename:0x00007f85e6d53f90 @filename="foo.png">, content_type="image/png", format=nil>>
user.avatar.metadata      # => {"identified"=>true}
user.avatar.content_type  # => "image/png"
user.avatar.image?        # => true
user.avatar.audio?        # => false
user.avatar.video?        # => false
user.avatar.text?         # => false
user.avatar.download.size # => 6646
Rails.application.routes.url_helpers.rails_blob_path(user.avatar, only_path: true) # => "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--ee58a1a6a6e306e7c3849ce8792a1df3c6ccdba2/foo.png"

User.with_attached_avatar.to_sql # => "SELECT `users`.* FROM `users`"

tp ActiveStorage::Attachment
tp ActiveStorage::Blob

# 消す
# ActiveStorage::Attachment.count # => 1
# user.avatar.purge               # => nil
# user.avatar.purge               # => nil
# user.avatar.attached?           # => false
# ActiveStorage::Attachment.count # => 0

# >> |----+--------+-------------+-----------+---------+---------------------------|
# >> | id | name   | record_type | record_id | blob_id | created_at                |
# >> |----+--------+-------------+-----------+---------+---------------------------|
# >> |  1 | avatar | User        |        11 |       1 | 2020-06-05 22:21:16 +0900 |
# >> |----+--------+-------------+-----------+---------+---------------------------|
# >> |----+------------------------------+----------+--------------+----------------------+-----------+--------------------------+---------------------------|
# >> | id | key                          | filename | content_type | metadata             | byte_size | checksum                 | created_at                |
# >> |----+------------------------------+----------+--------------+----------------------+-----------+--------------------------+---------------------------|
# >> |  1 | gfob36v4oxgl0b3c15omqwzlmz84 | foo.png  | image/png    | {"identified"=>true} |      6646 | nAoHm913AdfnKb2VaCPRUw== | 2020-06-05 22:21:16 +0900 |
# >> |----+------------------------------+----------+--------------+----------------------+-----------+--------------------------+---------------------------|
