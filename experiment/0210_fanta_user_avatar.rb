#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
Dir.chdir Rails.root

# ActiveSupport::LogSubscriber.colorize_logging = false
# ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)

ActiveStorage::Attachment.destroy_all

file = "spec/rails.png"

# どの方法でもよい。
file2 = {io: File.open(file), filename: "foo.png", content_type: "image/png"}
# file2 = Rack::Test::UploadedFile.new(file, "image/png", :binary)
# file2 = ActionDispatch::Http::UploadedFile.new(filename: File.basename(file), type: "image/png", tempfile: Tempfile.new(file)) # ← セットはできるけど、なぜか variant が失敗する

user = Fanta::User.create!
# ↓これは user.avatar = file とするのと同じに見えるけど、avatars.attach の場合だと配列でも指定できるのでこっちを使った方がよい
user.avatar.attach(file2)        # => nil
user.avatar                                                                        # => #<ActiveStorage::Attached::One:0x00007f9bd8710108 @name="avatar", @record=#<Fanta::User id: 63, name: "名無しの棋士63号", current_battle_id: nil, online_at: nil, fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", team_key: "team_p1vs1", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", created_at: "2018-06-15 05:04:16", updated_at: "2018-06-15 05:04:17">, @dependent=:purge_later>
user.avatar.attached?                                                              # => true
user.reload
user.avatar.variant(resize: "32x32", monochrome: true).processed rescue $!         # => #<ActiveStorage::Variant:0x00007f9bdc370fa8 @blob=#<ActiveStorage::Blob id: 64, key: "S7HayiJR9R7NuV7jf37ziEN5", filename: "foo.png", content_type: "image/png", metadata: {"identified"=>true}, byte_size: 6646, checksum: "nAoHm913AdfnKb2VaCPRUw==", created_at: "2018-06-15 05:04:17">, @variation=#<ActiveStorage::Variation:0x00007f9bd8c978d8 @transformations={:resize=>"32x32", :monochrome=>true}>>
user.avatar.metadata                                                               # => {"identified"=>true}
user.avatar.content_type                                                               # => "image/png"
user.avatar.image?                                                               # => true
user.avatar.audio?                                                               # => false
user.avatar.video?                                                               # => false
user.avatar.text?                                                               # => false
user.avatar.download.size                                                          # => 6646
Rails.application.routes.url_helpers.rails_blob_path(user.avatar, only_path: true) # => "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBSUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--864e10224f289a65b8b5a8e557a58f12263af655/foo.png"

Fanta::User.with_attached_avatar.to_sql # => "SELECT `fanta_users`.* FROM `fanta_users`"

tp ActiveStorage::Attachment

# 消す
ActiveStorage::Attachment.count # => 1
user.avatar.purge               # => nil
user.avatar.purge               # => nil
user.avatar.attached?           # => false
ActiveStorage::Attachment.count # => 0

# >> ["/Users/ikeda/src/shogi_web/config/initializers/0180_active_model_serializers.rb:11", nil, :ams_sr]
# >> D, [2018-06-15T14:04:17.022377 #96040] DEBUG -- : No serializer found for resource: #<Fanta::User id: 1, name: "名無しの棋士1号", current_battle_id: nil, online_at: "2018-06-15 02:24:11", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", team_key: "team_p2vs2", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", created_at: "2018-06-15 02:24:11", updated_at: "2018-06-15 02:24:11">
# >> I, [2018-06-15T14:04:17.026080 #96040]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (3.5ms)
# >> D, [2018-06-15T14:04:17.254026 #96040] DEBUG -- : No serializer found for resource: #<Fanta::User id: 1, name: "名無しの棋士1号", current_battle_id: nil, online_at: "2018-06-15 02:24:11", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", team_key: "team_p2vs2", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", created_at: "2018-06-15 02:24:11", updated_at: "2018-06-15 02:24:11">
# >> I, [2018-06-15T14:04:17.256502 #96040]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (2.36ms)
# >> |----+--------+-------------+-----------+---------+---------------------------|
# >> | id | name   | record_type | record_id | blob_id | created_at                |
# >> |----+--------+-------------+-----------+---------+---------------------------|
# >> | 52 | avatar | Fanta::User |        63 |      64 | 2018-06-15 14:04:17 +0900 |
# >> |----+--------+-------------+-----------+---------+---------------------------|
# >> D, [2018-06-15T14:04:17.403821 #96040] DEBUG -- : No serializer found for resource: #<Fanta::User id: 1, name: "名無しの棋士1号", current_battle_id: nil, online_at: "2018-06-15 02:24:11", fighting_at: nil, matching_at: nil, lifetime_key: "lifetime_m5", team_key: "team_p2vs2", self_preset_key: "平手", oppo_preset_key: "平手", user_agent: "", created_at: "2018-06-15 02:24:11", updated_at: "2018-06-15 02:24:11">
# >> I, [2018-06-15T14:04:17.406587 #96040]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with Fanta::User::ActiveRecord_Relation (2.67ms)
