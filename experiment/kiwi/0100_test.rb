require "./setup"

# Kiwi::Book.destroy_all
# Kiwi::Lemon.destroy_all
Kiwi::Folder.setup

user1 = User.sysop
params1 = {
  :body => "position startpos moves 7g7f 8c8d",
  :all_params => {
    :media_builder_params => {
      :recipe_key      => "is_recipe_mp4",
      :audio_theme_key => "audio_theme_is_none",
      :color_theme_key => "color_theme_is_real_wood1",
      :cover_text => "(cover_text.title)\n(cover_text.description)",
      # :width           => 2,
      # :height          => 2,
    },
  },
}
free_battle = user1.free_battles.create!(kifu_body: params1[:body], use_key: "kiwi_lemon")
tp free_battle
lemon1 = user1.kiwi_lemons.create!(recordable: free_battle, all_params: params1[:all_params])
lemon1.main_process
lemon1.reload
lemon1.status_key                  # => "成功"
lemon1.browser_path                # => "/system/x-files/1f/84/2_20210930184920_1200x630_4s.mp4"
lemon1.real_path                   # => #<Pathname:/Users/ikeda/src/shogi-extend/public/system/x-files/1f/84/2_20210930184920_1200x630_4s.mp4>
lemon1.thumbnail_browser_path.to_s # => "/system/x-files/1f/84/2_20210930184920_1200x630_4s_thumbnail.png"
lemon1.thumbnail_real_path.to_s    # => "/Users/ikeda/src/shogi-extend/public/system/x-files/1f/84/2_20210930184920_1200x630_4s_thumbnail.png"
tp lemon1

# フォーム初期値
book1 = user1.kiwi_books.build(lemon: lemon1) # => #<Kiwi::Book id: nil, key: nil, user_id: 1, folder_id: nil, lemon_id: 2, title: nil, description: nil, thumbnail_pos: nil, book_messages_count: 0, created_at: nil, updated_at: nil, tag_list: nil>
book1.form_values_default_assign
tp book1.attributes             # => {"id"=>nil, "key"=>nil, "user_id"=>1, "folder_id"=>nil, "lemon_id"=>2, "title"=>"(cover_text.title)", "description"=>"(cover_text.description)\n", "thumbnail_pos"=>nil, "book_messages_count"=>0, "created_at"=>nil, "updated_at"=>nil, "tag_list"=>["居飛車", "相居飛車"]}
book1.lemon                     # => #<Kiwi::Lemon id: 2, user_id: 1, recordable_type: "FreeBattle", recordable_id: 43, all_params: {:media_builder_params=>{:recipe_key=>"is_recipe_mp4", :audio_theme_key=>"audio_theme_is_none", :color_theme_key=>"color_theme_is_real_wood1", :cover_text=>"(cover_text.title)\n(cover_text.description)", :renderer_override_params=>{}}}, process_begin_at: "2021-09-30 18:49:20.000000000 +0900", process_end_at: "2021-09-30 18:49:28.000000000 +0900", successed_at: "2021-09-30 18:49:28.000000000 +0900", errored_at: nil, error_message: nil, file_size: 135006, ffprobe_info: {:pretty_format=>{"streams"=>[{"index"=>0, "codec_name"=>"h264", "codec_long_name"=>"H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10", "profile"=>"High", "codec_type"=>"video", "codec_tag_string"=>"avc1", "codec_tag"=>"0x31637661", "width"=>1200, "height"=>630, "coded_width"=>1200, "coded_height"=>630, "closed_captions"=>0, "has_b_frames"=>2, "pix_fmt"=>"yuv420p", "level"=>31, "chroma_location"=>"left", "refs"=>1, "is_avc"=>"true", "nal_length_size"=>"4", "r_frame_rate"=>"1/1", "avg_frame_rate"=>"1/1", "time_base"=>"1/16384", "start_pts"=>0, "start_time"=>"0:00:00.000000", "duration_ts"=>65536, "duration"=>"0:00:04.000000", "bit_rate"=>"268.048000 Kbit/s", "bits_per_raw_sample"=>"8", "nb_frames"=>"4", "disposition"=>{"default"=>1, "dub"=>0, "original"=>0, "comment"=>0, "lyrics"=>0, "karaoke"=>0, "forced"=>0, "hearing_impaired"=>0, "visual_impaired"=>0, "clean_effects"=>0, "attached_pic"=>0, "timed_thumbnails"=>0}, "tags"=>{"language"=>"und", "handler_name"=>"VideoHandler", "vendor_id"=>"[0][0][0][0]"}}]}, :direct_format=>{"streams"=>[{"index"=>0, "codec_name"=>"h264", "codec_long_name"=>"H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10", "profile"=>"High", "codec_type"=>"video", "codec_tag_string"=>"avc1", "codec_tag"=>"0x31637661", "width"=>1200, "height"=>630, "coded_width"=>1200, "coded_height"=>630, "closed_captions"=>0, "has_b_frames"=>2, "pix_fmt"=>"yuv420p", "level"=>31, "chroma_location"=>"left", "refs"=>1, "is_avc"=>"true", "nal_length_size"=>"4", "r_frame_rate"=>"1/1", "avg_frame_rate"=>"1/1", "time_base"=>"1/16384", "start_pts"=>0, "start_time"=>"0.000000", "duration_ts"=>65536, "duration"=>"4.000000", "bit_rate"=>"268048", "bits_per_raw_sample"=>"8", "nb_frames"=>"4", "disposition"=>{"default"=>1, "dub"=>0, "original"=>0, "comment"=>0, "lyrics"=>0, "karaoke"=>0, "forced"=>0, "hearing_impaired"=>0, "visual_impaired"=>0, "clean_effects"=>0, "attached_pic"=>0, "timed_thumbnails"=>0}, "tags"=>{"language"=>"und", "handler_name"=>"VideoHandler", "vendor_id"=>"[0][0][0][0]"}}]}}, browser_path: "/system/x-files/1f/84/2_20210930184920_1200x630_4s...", filename_human: "2_20210930184920_1200x630_4s.mp4", created_at: "2021-09-30 18:49:20.609796000 +0900", updated_at: "2021-09-30 18:49:28.337323000 +0900">

book1 = user1.kiwi_books.create!(lemon: lemon1, title: "タイトル#{user1.kiwi_books.count.next}" * 4, description: "description" * 4, tag_list: %w(居飛車 嬉野流 右玉))
book1.thumbnail_pos                 # => 0.0
lemon1.thumbnail_real_path      # => #<Pathname:/Users/ikeda/src/shogi-extend/public/system/x-files/1f/84/2_20210930184920_1200x630_4s_thumbnail.png>
lemon1.thumbnail_browser_path   # => "/system/x-files/1f/84/2_20210930184920_1200x630_4s_thumbnail.png"
book1.avatar_path               # => "/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBEQT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--922cd7a8c4e3c07726650d962055f8ac03bf8ba8/1f9641c57287c47244fcbe459a8e9a50.png"
tp book1 # => #<Kiwi::Book id: 1, key: "gt0Hav3VHv7", user_id: 1, folder_id: 3, lemon_id: 2, title: "タイトル1タイトル1タイトル1タイトル1", description: "descriptiondescriptiondescriptiondescription", thumbnail_pos: 0.0, book_messages_count: 0, created_at: "2021-09-30 18:49:29.436192000 +0900", updated_at: "2021-09-30 18:49:29.436192000 +0900", tag_list: ["居飛車", "嬉野流", "右玉"]>
lemon1.book # => #<Kiwi::Book id: 1, key: "gt0Hav3VHv7", user_id: 1, folder_id: 3, lemon_id: 2, title: "タイトル1タイトル1タイトル1タイトル1", description: "descriptiondescriptiondescriptiondescription", thumbnail_pos: 0.0, book_messages_count: 0, created_at: "2021-09-30 18:49:29.436192000 +0900", updated_at: "2021-09-30 18:49:29.436192000 +0900", tag_list: ["居飛車", "嬉野流", "右玉"]>

book1.book_messages.create!(user: user1, body: "(message1)")      # => #<Kiwi::BookMessage id: 1, user_id: 1, book_id: 1, body: "(message1)", created_at: "2021-09-30 18:49:29.512115000 +0900", updated_at: "2021-09-30 18:49:29.512115000 +0900">
user1.kiwi_book_messages.create!(book: book1, body: "(message1)") # => #<Kiwi::BookMessage id: 2, user_id: 1, book_id: 1, body: "(message1)", created_at: "2021-09-30 18:49:29.525954000 +0900", updated_at: "2021-09-30 18:49:29.525954000 +0900">
user1.kiwi_book_message_speak(book1, "(message1)")                # => #<Kiwi::BookMessage id: 3, user_id: 1, book_id: 1, body: "(message1)", created_at: "2021-09-30 18:49:29.535772000 +0900", updated_at: "2021-09-30 18:49:29.535772000 +0900">

tp user1.kiwi_book_messages

ActiveSupport::LogSubscriber.colorize_logging = false
logger = ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)

book1.book_messages.to_a

ActiveRecord::Base.logger = logger

# >> |--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                 id | 43                                                                                                                                                                   |
# >> |                key | 1f847f6f630bac4acd9e89b5e3acda7f                                                                                                                                     |
# >> |              title |                                                                                                                                                                      |
# >> |          kifu_body | position startpos moves 7g7f 8c8d                                                                                                                                    |
# >> |          sfen_body | position startpos moves 7g7f 8c8d                                                                                                                                    |
# >> |           turn_max | 2                                                                                                                                                                    |
# >> |          meta_info | {:black=>{:defense=>[], :attack=>[], :technique=>[], :note=>[:居飛車, :相居飛車]}, :white=>{:defense=>[], :attack=>[], :technique=>[], :note=>[:居飛車, :相居飛車]}} |
# >> |         battled_at | 0001-01-01 00:00:00 +0918                                                                                                                                            |
# >> |            use_key | kiwi_lemon                                                                                                                                                           |
# >> |        accessed_at | 2021-09-30 18:49:19 +0900                                                                                                                                            |
# >> |            user_id | 1                                                                                                                                                                    |
# >> |         preset_key | 平手                                                                                                                                                                 |
# >> |        description |                                                                                                                                                                      |
# >> |          sfen_hash | f7625f17e18fa9af278c5f81287d933e                                                                                                                                     |
# >> |         start_turn |                                                                                                                                                                      |
# >> |      critical_turn |                                                                                                                                                                      |
# >> |      outbreak_turn |                                                                                                                                                                      |
# >> |         image_turn |                                                                                                                                                                      |
# >> |         created_at | 2021-09-30 18:49:20 +0900                                                                                                                                            |
# >> |         updated_at | 2021-09-30 18:49:20 +0900                                                                                                                                            |
# >> |   defense_tag_list |                                                                                                                                                                      |
# >> |    attack_tag_list |                                                                                                                                                                      |
# >> | technique_tag_list |                                                                                                                                                                      |
# >> |      note_tag_list |                                                                                                                                                                      |
# >> |     other_tag_list |                                                                                                                                                                      |
# >> |--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |               id | 2                                                                                                                                                                                                                                                                   |
# >> |          user_id | 1                                                                                                                                                                                                                                                                   |
# >> |  recordable_type | FreeBattle                                                                                                                                                                                                                                                          |
# >> |    recordable_id | 43                                                                                                                                                                                                                                                                  |
# >> |       all_params | {:media_builder_params=>{:recipe_key=>"is_recipe_mp4", :audio_theme_key=>"audio_theme_is_none", :color_theme_key=>"color_theme_is_real_wood1", :cover_text=>"(cover_text.title)\n(cover_text.description)", :renderer_override_params=>{}}}                         |
# >> | process_begin_at | 2021-09-30 18:49:20 +0900                                                                                                                                                                                                                                           |
# >> |   process_end_at | 2021-09-30 18:49:28 +0900                                                                                                                                                                                                                                           |
# >> |     successed_at | 2021-09-30 18:49:28 +0900                                                                                                                                                                                                                                           |
# >> |       errored_at |                                                                                                                                                                                                                                                                     |
# >> |    error_message |                                                                                                                                                                                                                                                                     |
# >> |        file_size | 135006                                                                                                                                                                                                                                                              |
# >> |     ffprobe_info | {:pretty_format=>{"streams"=>[{"index"=>0, "codec_name"=>"h264", "codec_long_name"=>"H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10", "profile"=>"High", "codec_type"=>"video", "codec_tag_string"=>"avc1", "codec_tag"=>"0x31637661", "width"=>1200, "height"=>630, ... |
# >> |     browser_path | /system/x-files/1f/84/2_20210930184920_1200x630_4s.mp4                                                                                                                                                                                                              |
# >> |   filename_human | 2_20210930184920_1200x630_4s.mp4                                                                                                                                                                                                                                    |
# >> |       created_at | 2021-09-30 18:49:20 +0900                                                                                                                                                                                                                                           |
# >> |       updated_at | 2021-09-30 18:49:28 +0900                                                                                                                                                                                                                                           |
# >> |------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |---------------------+----------------------------|
# >> |                  id |                            |
# >> |                 key |                            |
# >> |             user_id | 1                          |
# >> |           folder_id |                            |
# >> |            lemon_id | 2                          |
# >> |               title | (cover_text.title)         |
# >> |         description | (cover_text.description)\n |
# >> |       thumbnail_pos |                            |
# >> | book_messages_count | 0                          |
# >> |          created_at |                            |
# >> |          updated_at |                            |
# >> |            tag_list | 居飛車 相居飛車            |
# >> |---------------------+----------------------------|
# >> |---------------------+----------------------------------------------|
# >> |                  id | 1                                            |
# >> |                 key | gt0Hav3VHv7                                  |
# >> |             user_id | 1                                            |
# >> |           folder_id | 3                                            |
# >> |            lemon_id | 2                                            |
# >> |               title | タイトル1タイトル1タイトル1タイトル1         |
# >> |         description | descriptiondescriptiondescriptiondescription |
# >> |       thumbnail_pos | 0.0                                          |
# >> | book_messages_count | 0                                            |
# >> |          created_at | 2021-09-30 18:49:29 +0900                    |
# >> |          updated_at | 2021-09-30 18:49:29 +0900                    |
# >> |            tag_list | 居飛車 嬉野流 右玉                           |
# >> |---------------------+----------------------------------------------|
# >> |----+---------+---------+------------+---------------------------+---------------------------|
# >> | id | user_id | book_id | body       | created_at                | updated_at                |
# >> |----+---------+---------+------------+---------------------------+---------------------------|
# >> |  1 |       1 |       1 | (message1) | 2021-09-30 18:49:29 +0900 | 2021-09-30 18:49:29 +0900 |
# >> |  2 |       1 |       1 | (message1) | 2021-09-30 18:49:29 +0900 | 2021-09-30 18:49:29 +0900 |
# >> |  3 |       1 |       1 | (message1) | 2021-09-30 18:49:29 +0900 | 2021-09-30 18:49:29 +0900 |
# >> |----+---------+---------+------------+---------------------------+---------------------------|
# >>   Kiwi::BookMessage Load (0.4ms)  SELECT `kiwi_book_messages`.* FROM `kiwi_book_messages` WHERE `kiwi_book_messages`.`book_id` = 1
