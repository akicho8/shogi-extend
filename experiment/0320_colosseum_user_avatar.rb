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
file2 = {io: StringIO.open(Pathname(file).read), filename: "foo.png" }
# file2 = {io: StringIO.open(Pathname(file).read), filename: "foo.png"} # content_type はなくてもいい。, content_type: "image/png"
# file2 = {io: File.open(file), filename: "foo.png", content_type: "image/png"}
# file2 = Rack::Test::UploadedFile.new(file, "image/png", :binary)
# file2 = ActionDispatch::Http::UploadedFile.new(filename: File.basename(file), type: "image/png", tempfile: Tempfile.new(file)) # ← セットはできるけど、なぜか variant が失敗する

user = Colosseum::User.create!
# ↓これは user.avatar = file とするのと同じに見えるけど、avatars.attach の場合だと配列でも指定できるのでこっちを使った方がよい
user.avatar.attach(file2)        # => nil
user.avatar                                                                        # => #<ActiveStorage::Attached::One:0x00007fa391a96fc8 @name="avatar", @record=#<Colosseum::User id: 42, key: "3e4cddd3e5ac8017512f070cfe5e1ac4", name: "名無しの棋士33号", online_at: "2018-10-18 02:43:46", fighting_at: nil, matching_at: nil, cpu_brain_key: nil, user_agent: "", race_key: "human", created_at: "2018-10-18 02:43:46", updated_at: "2018-10-18 02:43:48", email: "3e4cddd3e5ac8017512f070cfe5e1ac4@localhost">, @dependent=:purge_later>
user.avatar.attached?                                                              # => true
user.reload
user.avatar.variant(resize: "32x32", monochrome: true).processed rescue $!         # => #<ActiveStorage::Variant:0x00007fa399b519d8 @blob=#<ActiveStorage::Blob id: 28, key: "8pihEmpD3VyTL67dztZZzHCX", filename: "foo.png", content_type: "image/png", metadata: {"identified"=>true}, byte_size: 6646, checksum: "nAoHm913AdfnKb2VaCPRUw==", created_at: "2018-10-18 02:43:48">, @variation=#<ActiveStorage::Variation:0x00007fa399b41fd8 @transformations={:resize=>"32x32", :monochrome=>true}>>
user.avatar.metadata                                                               # => {"identified"=>true}
user.avatar.content_type                                                               # => "image/png"
user.avatar.image?                                                               # => true
user.avatar.audio?                                                               # => false
user.avatar.video?                                                               # => false
user.avatar.text?                                                               # => false
user.avatar.download.size                                                          # => 6646
Rails.application.routes.url_helpers.rails_blob_path(user.avatar, only_path: true) # => "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBJUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--36df0e3f498bf73b493ee4ec5f9697be335ba6cb/foo.png"

Colosseum::User.with_attached_avatar.to_sql # => "SELECT `colosseum_users`.* FROM `colosseum_users`"

sleep(2)
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
# >> | 28 | avatar | Colosseum::User |        42 |      28 | 2018-10-18 11:43:48 +0900 |
# >> |----+--------+-----------------+-----------+---------+---------------------------|
# >> |----+--------------------------+----------+--------------+-------------------------------------------------------------------+-----------+--------------------------+---------------------------|
# >> | id | key                      | filename | content_type | metadata                                                          | byte_size | checksum                 | created_at                |
# >> |----+--------------------------+----------+--------------+-------------------------------------------------------------------+-----------+--------------------------+---------------------------|
# >> | 28 | 8pihEmpD3VyTL67dztZZzHCX | foo.png  | image/png    | {"identified"=>true, "width"=>50, "height"=>64, "analyzed"=>true} |      6646 | nAoHm913AdfnKb2VaCPRUw== | 2018-10-18 11:43:48 +0900 |
# >> |----+--------------------------+----------+--------------+-------------------------------------------------------------------+-----------+--------------------------+---------------------------|
