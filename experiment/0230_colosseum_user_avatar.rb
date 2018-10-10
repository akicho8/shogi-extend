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
file2 = {io: StringIO.new(Pathname(file).read), filename: "foo.png", content_type: "image/png"}
# file2 = {io: File.open(file), filename: "foo.png", content_type: "image/png"}
# file2 = Rack::Test::UploadedFile.new(file, "image/png", :binary)
# file2 = ActionDispatch::Http::UploadedFile.new(filename: File.basename(file), type: "image/png", tempfile: Tempfile.new(file)) # ← セットはできるけど、なぜか variant が失敗する

user = Colosseum::User.create!
# ↓これは user.avatar = file とするのと同じに見えるけど、avatars.attach の場合だと配列でも指定できるのでこっちを使った方がよい
user.avatar.attach(file2)        # => nil
user.avatar                                                                        # => #<ActiveStorage::Attached::One:0x00007fadcf821fc0 @name="avatar", @record=#<Colosseum::User id: 24, key: "c342526e2880a7339db2511f55013a18", name: "名無しの棋士15号", online_at: "2018-10-10 04:15:20", fighting_at: nil, matching_at: nil, cpu_brain_key: nil, user_agent: "", race_key: "human", created_at: "2018-10-10 04:15:20", updated_at: "2018-10-10 04:15:22", email: "c342526e2880a7339db2511f55013a18@localhost">, @dependent=:purge_later>
user.avatar.attached?                                                              # => true
user.reload
user.avatar.variant(resize: "32x32", monochrome: true).processed rescue $!         # => #<ActiveStorage::Variant:0x00007fadd5261940 @blob=#<ActiveStorage::Blob id: 12, key: "6UfPjsqhPBx7R1EhnHzxU7wz", filename: "foo.png", content_type: "image/png", metadata: {"identified"=>true}, byte_size: 6646, checksum: "nAoHm913AdfnKb2VaCPRUw==", created_at: "2018-10-10 04:15:22">, @variation=#<ActiveStorage::Variation:0x00007fadd5251d88 @transformations={:resize=>"32x32", :monochrome=>true}>>
user.avatar.metadata                                                               # => {"identified"=>true}
user.avatar.content_type                                                               # => "image/png"
user.avatar.image?                                                               # => true
user.avatar.audio?                                                               # => false
user.avatar.video?                                                               # => false
user.avatar.text?                                                               # => false
user.avatar.download.size                                                          # => 6646
Rails.application.routes.url_helpers.rails_blob_path(user.avatar, only_path: true) # => "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBFUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--f5a106e55d0a24ddf4ce23692efd07440849fdc0/foo.png"

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
# >> | 12 | avatar | Colosseum::User |        24 |      12 | 2018-10-10 13:15:22 +0900 |
# >> |----+--------+-----------------+-----------+---------+---------------------------|
# >> |----+--------------------------+----------+--------------+----------------------+-----------+--------------------------+---------------------------|
# >> | id | key                      | filename | content_type | metadata             | byte_size | checksum                 | created_at                |
# >> |----+--------------------------+----------+--------------+----------------------+-----------+--------------------------+---------------------------|
# >> | 12 | 6UfPjsqhPBx7R1EhnHzxU7wz | foo.png  | image/png    | {"identified"=>true} |      6646 | nAoHm913AdfnKb2VaCPRUw== | 2018-10-10 13:15:22 +0900 |
# >> |----+--------------------------+----------+--------------+----------------------+-----------+--------------------------+---------------------------|
