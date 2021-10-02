require "./setup"

# Kiwi::Book.destroy_all
# Kiwi::Lemon.destroy_all
Kiwi::Folder.setup

user1 = User.sysop
params1 = {
  :body => "position startpos moves 7g7f 8c8d",
  :all_params => {
    :media_builder_params => {
      :recipe_key      => "is_recipe_webp",
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
lemon1.browser_path                # => "/system/x-files/74/2c/11_20211002135636_0x0.webp"
lemon1.real_path                   # => #<Pathname:/Users/ikeda/src/shogi-extend/public/system/x-files/74/2c/11_20211002135636_0x0.webp>
lemon1.thumbnail_browser_path.to_s # => ""
lemon1.thumbnail_real_path.to_s    # => ""
tp lemon1

# フォーム初期値
book1 = user1.kiwi_books.build(lemon: lemon1) # => #<Kiwi::Book id: nil, key: nil, user_id: 1, folder_id: nil, lemon_id: 11, title: nil, description: nil, thumbnail_pos: nil, book_messages_count: 0, access_logs_count: 0, created_at: nil, updated_at: nil, tag_list: nil>
book1.form_values_default_assign
tp book1.attributes             # => {"id"=>nil, "key"=>nil, "user_id"=>1, "folder_id"=>nil, "lemon_id"=>11, "title"=>"(cover_text.title)", "description"=>"(cover_text.description)", "thumbnail_pos"=>0.0, "book_messages_count"=>0, "access_logs_count"=>0, "created_at"=>nil, "updated_at"=>nil, "tag_list"=>["居飛車", "相居飛車"]}
book1.lemon                     # => #<Kiwi::Lemon id: 11, user_id: 1, recordable_type: "FreeBattle", recordable_id: 35, all_params: {:media_builder_params=>{:recipe_key=>"is_recipe_webp", :audio_theme_key=>"audio_theme_is_none", :color_theme_key=>"color_theme_is_real_wood1", :cover_text=>"(cover_text.title)\n(cover_text.description)", :renderer_override_params=>{}}}, process_begin_at: "2021-10-02 13:56:36.000000000 +0900", process_end_at: "2021-10-02 13:56:43.000000000 +0900", successed_at: "2021-10-02 13:56:43.000000000 +0900", errored_at: nil, error_message: nil, content_type: "image/webp", file_size: 53310, ffprobe_info: {:pretty_format=>{"streams"=>[{"index"=>0, "codec_name"=>"webp", "codec_long_name"=>"WebP", "codec_type"=>"video", "codec_tag_string"=>"[0][0][0][0]", "codec_tag"=>"0x0000", "width"=>0, "height"=>0, "coded_width"=>0, "coded_height"=>0, "closed_captions"=>0, "has_b_frames"=>0, "level"=>-99, "refs"=>1, "r_frame_rate"=>"25/1", "avg_frame_rate"=>"25/1", "time_base"=>"1/25", "disposition"=>{"default"=>0, "dub"=>0, "original"=>0, "comment"=>0, "lyrics"=>0, "karaoke"=>0, "forced"=>0, "hearing_impaired"=>0, "visual_impaired"=>0, "clean_effects"=>0, "attached_pic"=>0, "timed_thumbnails"=>0}}]}, :direct_format=>{"streams"=>[{"index"=>0, "codec_name"=>"webp", "codec_long_name"=>"WebP", "codec_type"=>"video", "codec_tag_string"=>"[0][0][0][0]", "codec_tag"=>"0x0000", "width"=>0, "height"=>0, "coded_width"=>0, "coded_height"=>0, "closed_captions"=>0, "has_b_frames"=>0, "level"=>-99, "refs"=>1, "r_frame_rate"=>"25/1", "avg_frame_rate"=>"25/1", "time_base"=>"1/25", "disposition"=>{"default"=>0, "dub"=>0, "original"=>0, "comment"=>0, "lyrics"=>0, "karaoke"=>0, "forced"=>0, "hearing_impaired"=>0, "visual_impaired"=>0, "clean_effects"=>0, "attached_pic"=>0, "timed_thumbnails"=>0}}]}}, browser_path: "/system/x-files/74/2c/11_20211002135636_0x0.webp", filename_human: "11_20211002135636_0x0.webp", created_at: "2021-10-02 13:56:36.567149000 +0900", updated_at: "2021-10-02 13:56:43.344537000 +0900">

book1 = user1.kiwi_books.create!(lemon: lemon1, folder_key: "public", title: "タイトル#{user1.kiwi_books.count.next}" * 4, description: "description" * 4, tag_list: %w(居飛車 嬉野流 右玉))
book1.thumbnail_pos                 # => 0.0
lemon1.thumbnail_real_path      # => nil
lemon1.thumbnail_browser_path   # => nil
book1.avatar_path               # => "/assets/book/0004_fallback_book_icon-c14a2ce9e308c78478c0fbb891316db77b163fbbb728ae783bbefff6873fa538.png"
tp book1 # => #<Kiwi::Book id: 11, key: "qrkyCoIPgIo", user_id: 1, folder_id: 1, lemon_id: 11, title: "タイトル11タイトル11タイトル11タイトル11", description: "descriptiondescriptiondescriptiondescription", thumbnail_pos: 0.0, book_messages_count: 0, access_logs_count: 0, created_at: "2021-10-02 13:56:43.474410000 +0900", updated_at: "2021-10-02 13:56:43.474410000 +0900", tag_list: ["居飛車", "嬉野流", "右玉"]>
lemon1.book # => #<Kiwi::Book id: 11, key: "qrkyCoIPgIo", user_id: 1, folder_id: 1, lemon_id: 11, title: "タイトル11タイトル11タイトル11タイトル11", description: "descriptiondescriptiondescriptiondescription", thumbnail_pos: 0.0, book_messages_count: 0, access_logs_count: 0, created_at: "2021-10-02 13:56:43.474410000 +0900", updated_at: "2021-10-02 13:56:43.474410000 +0900", tag_list: ["居飛車", "嬉野流", "右玉"]>

# アクセスログ
book1.access_logs.create!(user: user1) # => #<Kiwi::AccessLog id: 126, user_id: 1, book_id: 11, created_at: "2021-10-02 13:56:43.000000000 +0900">
tp user1.kiwi_access_logs                 # => #<ActiveRecord::Associations::CollectionProxy [#<Kiwi::AccessLog id: 4, user_id: 1, book_id: 4, created_at: "2021-10-02 10:47:45.000000000 +0900">, #<Kiwi::AccessLog id: 5, user_id: 1, book_id: 5, created_at: "2021-10-02 10:49:15.000000000 +0900">, #<Kiwi::AccessLog id: 6, user_id: 1, book_id: 6, created_at: "2021-10-02 10:53:20.000000000 +0900">, #<Kiwi::AccessLog id: 7, user_id: 1, book_id: 7, created_at: "2021-10-02 10:56:39.000000000 +0900">, #<Kiwi::AccessLog id: 8, user_id: 1, book_id: 8, created_at: "2021-10-02 10:58:40.000000000 +0900">, #<Kiwi::AccessLog id: 9, user_id: 1, book_id: 9, created_at: "2021-10-02 11:01:17.000000000 +0900">, #<Kiwi::AccessLog id: 10, user_id: 1, book_id: 10, created_at: "2021-10-02 11:35:10.000000000 +0900">, #<Kiwi::AccessLog id: 11, user_id: 1, book_id: 1, created_at: "2021-10-02 11:36:17.000000000 +0900">, #<Kiwi::AccessLog id: 12, user_id: 1, book_id: 1, created_at: "2021-10-02 11:39:51.000000000 +0900">, #<Kiwi::AccessLog id: 13, user_id: 1, book_id: 1, created_at: "2021-10-02 11:39:53.000000000 +0900">, ...]>
tp user1.kiwi_access_logs.first.book      # => #<Kiwi::Book id: 4, key: "WbtOrG8oW0Z", user_id: 1, folder_id: 3, lemon_id: 4, title: "タイトル4タイトル4タイトル4タイトル4", description: "descriptiondescriptiondescriptiondescription", thumbnail_pos: 0.0, book_messages_count: 0, access_logs_count: 1, created_at: "2021-10-02 10:47:45.872672000 +0900", updated_at: "2021-10-02 10:47:45.872672000 +0900", tag_list: nil>
tp user1.kiwi_access_books                 # => #<ActiveRecord::Associations::CollectionProxy [#<Kiwi::Book id: 1, key: "UC4gW1YaAD3", user_id: 1, folder_id: 3, lemon_id: 1, title: "タイトル1タイトル1タイトル1タイトル1", description: "descriptiondescriptiondescriptiondescription", thumbnail_pos: 0.0, book_messages_count: 0, access_logs_count: 34, created_at: "2021-10-02 10:35:34.719211000 +0900", updated_at: "2021-10-02 10:35:34.719211000 +0900", tag_list: nil>, #<Kiwi::Book id: 1, key: "UC4gW1YaAD3", user_id: 1, folder_id: 3, lemon_id: 1, title: "タイトル1タイトル1タイトル1タイトル1", description: "descriptiondescriptiondescriptiondescription", thumbnail_pos: 0.0, book_messages_count: 0, access_logs_count: 34, created_at: "2021-10-02 10:35:34.719211000 +0900", updated_at: "2021-10-02 10:35:34.719211000 +0900", tag_list: nil>, #<Kiwi::Book id: 1, key: "UC4gW1YaAD3", user_id: 1, folder_id: 3, lemon_id: 1, title: "タイトル1タイトル1タイトル1タイトル1", description: "descriptiondescriptiondescriptiondescription", thumbnail_pos: 0.0, book_messages_count: 0, access_logs_count: 34, created_at: "2021-10-02 10:35:34.719211000 +0900", updated_at: "2021-10-02 10:35:34.719211000 +0900", tag_list: nil>, #<Kiwi::Book id: 1, key: "UC4gW1YaAD3", user_id: 1, folder_id: 3, lemon_id: 1, title: "タイトル1タイトル1タイトル1タイトル1", description: "descriptiondescriptiondescriptiondescription", thumbnail_pos: 0.0, book_messages_count: 0, access_logs_count: 34, created_at: "2021-10-02 10:35:34.719211000 +0900", updated_at: "2021-10-02 10:35:34.719211000 +0900", tag_list: nil>, #<Kiwi::Book id: 1, key: "UC4gW1YaAD3", user_id: 1, folder_id: 3, lemon_id: 1, title: "タイトル1タイトル1タイトル1タイトル1", description: "descriptiondescriptiondescriptiondescription", thumbnail_pos: 0.0, book_messages_count: 0, access_logs_count: 34, created_at: "2021-10-02 10:35:34.719211000 +0900", updated_at: "2021-10-02 10:35:34.719211000 +0900", tag_list: nil>, #<Kiwi::Book id: 1, key: "UC4gW1YaAD3", user_id: 1, folder_id: 3, lemon_id: 1, title: "タイトル1タイトル1タイトル1タイトル1", description: "descriptiondescriptiondescriptiondescription", thumbnail_pos: 0.0, book_messages_count: 0, access_logs_count: 34, created_at: "2021-10-02 10:35:34.719211000 +0900", updated_at: "2021-10-02 10:35:34.719211000 +0900", tag_list: nil>, #<Kiwi::Book id: 1, key: "UC4gW1YaAD3", user_id: 1, folder_id: 3, lemon_id: 1, title: "タイトル1タイトル1タイトル1タイトル1", description: "descriptiondescriptiondescriptiondescription", thumbnail_pos: 0.0, book_messages_count: 0, access_logs_count: 34, created_at: "2021-10-02 10:35:34.719211000 +0900", updated_at: "2021-10-02 10:35:34.719211000 +0900", tag_list: nil>, #<Kiwi::Book id: 1, key: "UC4gW1YaAD3", user_id: 1, folder_id: 3, lemon_id: 1, title: "タイトル1タイトル1タイトル1タイトル1", description: "descriptiondescriptiondescriptiondescription", thumbnail_pos: 0.0, book_messages_count: 0, access_logs_count: 34, created_at: "2021-10-02 10:35:34.719211000 +0900", updated_at: "2021-10-02 10:35:34.719211000 +0900", tag_list: nil>, #<Kiwi::Book id: 1, key: "UC4gW1YaAD3", user_id: 1, folder_id: 3, lemon_id: 1, title: "タイトル1タイトル1タイトル1タイトル1", description: "descriptiondescriptiondescriptiondescription", thumbnail_pos: 0.0, book_messages_count: 0, access_logs_count: 34, created_at: "2021-10-02 10:35:34.719211000 +0900", updated_at: "2021-10-02 10:35:34.719211000 +0900", tag_list: nil>, #<Kiwi::Book id: 1, key: "UC4gW1YaAD3", user_id: 1, folder_id: 3, lemon_id: 1, title: "タイトル1タイトル1タイトル1タイトル1", description: "descriptiondescriptiondescriptiondescription", thumbnail_pos: 0.0, book_messages_count: 0, access_logs_count: 34, created_at: "2021-10-02 10:35:34.719211000 +0900", updated_at: "2021-10-02 10:35:34.719211000 +0900", tag_list: nil>, ...]>

# コメント
book1.book_messages.create!(user: user1, body: "(message1)")      # => #<Kiwi::BookMessage id: 7, user_id: 1, book_id: 11, body: "(message1)", created_at: "2021-10-02 13:56:43.846943000 +0900", updated_at: "2021-10-02 13:56:43.846943000 +0900">
user1.kiwi_book_messages.create!(book: book1, body: "(message1)") # => #<Kiwi::BookMessage id: 8, user_id: 1, book_id: 11, body: "(message1)", created_at: "2021-10-02 13:56:43.859458000 +0900", updated_at: "2021-10-02 13:56:43.859458000 +0900">
user1.kiwi_book_message_speak(book1, "(message1)")                # => #<Kiwi::BookMessage id: 9, user_id: 1, book_id: 11, body: "(message1)", created_at: "2021-10-02 13:56:43.870262000 +0900", updated_at: "2021-10-02 13:56:43.870262000 +0900">

tp user1.kiwi_book_messages

ActiveSupport::LogSubscriber.colorize_logging = false
logger = ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)

book1.book_messages.to_a

ActiveRecord::Base.logger = logger

# >> |--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                 id | 35                                                                                                                                                                   |
# >> |                key | 742c7b503ca3db938034cca4c4e38505                                                                                                                                     |
# >> |              title |                                                                                                                                                                      |
# >> |          kifu_body | position startpos moves 7g7f 8c8d                                                                                                                                    |
# >> |          sfen_body | position startpos moves 7g7f 8c8d                                                                                                                                    |
# >> |           turn_max | 2                                                                                                                                                                    |
# >> |          meta_info | {:black=>{:defense=>[], :attack=>[], :technique=>[], :note=>[:居飛車, :相居飛車]}, :white=>{:defense=>[], :attack=>[], :technique=>[], :note=>[:居飛車, :相居飛車]}} |
# >> |         battled_at | 0001-01-01 00:00:00 +0918                                                                                                                                            |
# >> |            use_key | kiwi_lemon                                                                                                                                                           |
# >> |        accessed_at | 2021-10-02 13:56:35 +0900                                                                                                                                            |
# >> |            user_id | 1                                                                                                                                                                    |
# >> |         preset_key | 平手                                                                                                                                                                 |
# >> |        description |                                                                                                                                                                      |
# >> |          sfen_hash | f7625f17e18fa9af278c5f81287d933e                                                                                                                                     |
# >> |         start_turn |                                                                                                                                                                      |
# >> |      critical_turn |                                                                                                                                                                      |
# >> |      outbreak_turn |                                                                                                                                                                      |
# >> |         image_turn |                                                                                                                                                                      |
# >> |         created_at | 2021-10-02 13:56:36 +0900                                                                                                                                            |
# >> |         updated_at | 2021-10-02 13:56:36 +0900                                                                                                                                            |
# >> |   defense_tag_list |                                                                                                                                                                      |
# >> |    attack_tag_list |                                                                                                                                                                      |
# >> | technique_tag_list |                                                                                                                                                                      |
# >> |      note_tag_list |                                                                                                                                                                      |
# >> |     other_tag_list |                                                                                                                                                                      |
# >> |--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |               id | 11                                                                                                                                                                                                                                                                  |
# >> |          user_id | 1                                                                                                                                                                                                                                                                   |
# >> |  recordable_type | FreeBattle                                                                                                                                                                                                                                                          |
# >> |    recordable_id | 35                                                                                                                                                                                                                                                                  |
# >> |       all_params | {:media_builder_params=>{:recipe_key=>"is_recipe_webp", :audio_theme_key=>"audio_theme_is_none", :color_theme_key=>"color_theme_is_real_wood1", :cover_text=>"(cover_text.title)\n(cover_text.description)", :renderer_override_params=>{}}}                        |
# >> | process_begin_at | 2021-10-02 13:56:36 +0900                                                                                                                                                                                                                                           |
# >> |   process_end_at | 2021-10-02 13:56:43 +0900                                                                                                                                                                                                                                           |
# >> |     successed_at | 2021-10-02 13:56:43 +0900                                                                                                                                                                                                                                           |
# >> |       errored_at |                                                                                                                                                                                                                                                                     |
# >> |    error_message |                                                                                                                                                                                                                                                                     |
# >> |     content_type | image/webp                                                                                                                                                                                                                                                          |
# >> |        file_size | 53310                                                                                                                                                                                                                                                               |
# >> |     ffprobe_info | {:pretty_format=>{"streams"=>[{"index"=>0, "codec_name"=>"webp", "codec_long_name"=>"WebP", "codec_type"=>"video", "codec_tag_string"=>"[0][0][0][0]", "codec_tag"=>"0x0000", "width"=>0, "height"=>0, "coded_width"=>0, "coded_height"=>0, "closed_captions"=>0... |
# >> |     browser_path | /system/x-files/74/2c/11_20211002135636_0x0.webp                                                                                                                                                                                                                    |
# >> |   filename_human | 11_20211002135636_0x0.webp                                                                                                                                                                                                                                          |
# >> |       created_at | 2021-10-02 13:56:36 +0900                                                                                                                                                                                                                                           |
# >> |       updated_at | 2021-10-02 13:56:43 +0900                                                                                                                                                                                                                                           |
# >> |------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |---------------------+--------------------------|
# >> |                  id |                          |
# >> |                 key |                          |
# >> |             user_id | 1                        |
# >> |           folder_id |                          |
# >> |            lemon_id | 11                       |
# >> |               title | (cover_text.title)       |
# >> |         description | (cover_text.description) |
# >> |       thumbnail_pos | 0.0                      |
# >> | book_messages_count | 0                        |
# >> |   access_logs_count | 0                        |
# >> |          created_at |                          |
# >> |          updated_at |                          |
# >> |            tag_list | 居飛車 相居飛車          |
# >> |---------------------+--------------------------|
# >> |---------------------+----------------------------------------------|
# >> |                  id | 11                                           |
# >> |                 key | qrkyCoIPgIo                                  |
# >> |             user_id | 1                                            |
# >> |           folder_id | 1                                            |
# >> |            lemon_id | 11                                           |
# >> |               title | タイトル11タイトル11タイトル11タイトル11     |
# >> |         description | descriptiondescriptiondescriptiondescription |
# >> |       thumbnail_pos | 0.0                                          |
# >> | book_messages_count | 0                                            |
# >> |   access_logs_count | 0                                            |
# >> |          created_at | 2021-10-02 13:56:43 +0900                    |
# >> |          updated_at | 2021-10-02 13:56:43 +0900                    |
# >> |            tag_list | 居飛車 嬉野流 右玉                           |
# >> |---------------------+----------------------------------------------|
# >> |-----+---------+---------+---------------------------|
# >> | id  | user_id | book_id | created_at                |
# >> |-----+---------+---------+---------------------------|
# >> |   4 |       1 |       4 | 2021-10-02 10:47:45 +0900 |
# >> |   5 |       1 |       5 | 2021-10-02 10:49:15 +0900 |
# >> |   6 |       1 |       6 | 2021-10-02 10:53:20 +0900 |
# >> |   7 |       1 |       7 | 2021-10-02 10:56:39 +0900 |
# >> |   8 |       1 |       8 | 2021-10-02 10:58:40 +0900 |
# >> |   9 |       1 |       9 | 2021-10-02 11:01:17 +0900 |
# >> |  10 |       1 |      10 | 2021-10-02 11:35:10 +0900 |
# >> |  11 |       1 |       1 | 2021-10-02 11:36:17 +0900 |
# >> |  12 |       1 |       1 | 2021-10-02 11:39:51 +0900 |
# >> |  13 |       1 |       1 | 2021-10-02 11:39:53 +0900 |
# >> |  14 |       1 |       1 | 2021-10-02 11:39:56 +0900 |
# >> |  15 |       1 |       1 | 2021-10-02 11:39:58 +0900 |
# >> |  16 |       1 |       1 | 2021-10-02 11:40:03 +0900 |
# >> |  17 |       1 |       1 | 2021-10-02 11:40:05 +0900 |
# >> |  18 |       1 |       1 | 2021-10-02 11:40:20 +0900 |
# >> |  19 |       1 |       1 | 2021-10-02 11:40:22 +0900 |
# >> |  20 |       1 |       1 | 2021-10-02 11:40:52 +0900 |
# >> |  21 |       1 |       1 | 2021-10-02 11:40:53 +0900 |
# >> |  22 |       1 |       1 | 2021-10-02 11:41:21 +0900 |
# >> |  23 |       1 |       1 | 2021-10-02 11:41:26 +0900 |
# >> |  24 |       1 |       1 | 2021-10-02 11:41:30 +0900 |
# >> |  25 |       1 |       1 | 2021-10-02 11:41:37 +0900 |
# >> |  26 |       1 |       1 | 2021-10-02 11:42:06 +0900 |
# >> |  27 |       1 |       1 | 2021-10-02 11:43:15 +0900 |
# >> |  28 |       1 |       1 | 2021-10-02 11:43:15 +0900 |
# >> |  29 |       1 |       1 | 2021-10-02 11:43:15 +0900 |
# >> |  30 |       1 |       1 | 2021-10-02 11:43:18 +0900 |
# >> |  31 |       1 |       1 | 2021-10-02 11:43:54 +0900 |
# >> |  32 |       1 |       1 | 2021-10-02 11:43:55 +0900 |
# >> |  33 |       1 |       1 | 2021-10-02 12:32:54 +0900 |
# >> |  34 |       1 |       1 | 2021-10-02 12:38:33 +0900 |
# >> |  35 |       1 |       2 | 2021-10-02 12:40:59 +0900 |
# >> |  36 |       1 |       2 | 2021-10-02 12:41:06 +0900 |
# >> |  37 |       1 |       2 | 2021-10-02 12:41:08 +0900 |
# >> |  38 |       1 |       2 | 2021-10-02 12:47:41 +0900 |
# >> |  39 |       1 |       2 | 2021-10-02 12:48:44 +0900 |
# >> |  40 |       1 |       2 | 2021-10-02 12:48:46 +0900 |
# >> |  41 |       1 |       2 | 2021-10-02 12:49:16 +0900 |
# >> |  42 |       1 |       2 | 2021-10-02 12:49:17 +0900 |
# >> |  43 |       1 |       2 | 2021-10-02 12:50:12 +0900 |
# >> |  44 |       1 |       2 | 2021-10-02 12:50:14 +0900 |
# >> |  45 |       1 |       2 | 2021-10-02 12:51:06 +0900 |
# >> |  46 |       1 |       2 | 2021-10-02 12:51:08 +0900 |
# >> |  47 |       1 |       2 | 2021-10-02 12:53:56 +0900 |
# >> |  48 |       1 |       2 | 2021-10-02 12:54:01 +0900 |
# >> |  49 |       1 |       2 | 2021-10-02 12:54:36 +0900 |
# >> |  50 |       1 |       2 | 2021-10-02 12:54:38 +0900 |
# >> |  51 |       1 |       2 | 2021-10-02 12:54:55 +0900 |
# >> |  52 |       1 |       2 | 2021-10-02 12:54:57 +0900 |
# >> |  53 |       1 |       2 | 2021-10-02 12:55:12 +0900 |
# >> |  54 |       1 |       2 | 2021-10-02 12:55:13 +0900 |
# >> |  55 |       1 |       2 | 2021-10-02 12:56:21 +0900 |
# >> |  56 |       1 |       2 | 2021-10-02 12:56:40 +0900 |
# >> |  57 |       1 |       2 | 2021-10-02 12:56:50 +0900 |
# >> |  58 |       1 |       2 | 2021-10-02 12:56:53 +0900 |
# >> |  59 |       1 |       2 | 2021-10-02 12:57:29 +0900 |
# >> |  60 |       1 |       2 | 2021-10-02 12:57:31 +0900 |
# >> |  61 |       1 |       1 | 2021-10-02 12:58:57 +0900 |
# >> |  62 |       1 |       1 | 2021-10-02 12:59:00 +0900 |
# >> |  63 |       1 |       1 | 2021-10-02 12:59:01 +0900 |
# >> |  64 |       1 |       1 | 2021-10-02 12:59:03 +0900 |
# >> |  65 |       1 |       1 | 2021-10-02 12:59:04 +0900 |
# >> |  66 |       1 |       1 | 2021-10-02 12:59:11 +0900 |
# >> |  67 |       1 |       1 | 2021-10-02 12:59:12 +0900 |
# >> |  68 |       1 |       1 | 2021-10-02 13:00:52 +0900 |
# >> |  69 |       1 |       2 | 2021-10-02 13:00:52 +0900 |
# >> |  70 |       1 |       2 | 2021-10-02 13:01:02 +0900 |
# >> |  71 |       1 |       1 | 2021-10-02 13:01:03 +0900 |
# >> |  72 |       1 |       1 | 2021-10-02 13:01:05 +0900 |
# >> |  73 |       1 |       2 | 2021-10-02 13:01:07 +0900 |
# >> |  74 |       1 |       2 | 2021-10-02 13:01:11 +0900 |
# >> |  75 |       1 |       2 | 2021-10-02 13:01:13 +0900 |
# >> |  76 |       1 |       2 | 2021-10-02 13:01:27 +0900 |
# >> |  77 |       1 |       2 | 2021-10-02 13:01:28 +0900 |
# >> |  78 |       1 |       2 | 2021-10-02 13:02:05 +0900 |
# >> |  79 |       1 |       2 | 2021-10-02 13:02:23 +0900 |
# >> |  80 |       1 |       2 | 2021-10-02 13:02:41 +0900 |
# >> |  81 |       1 |       2 | 2021-10-02 13:02:53 +0900 |
# >> |  82 |       1 |       2 | 2021-10-02 13:03:03 +0900 |
# >> |  83 |       1 |       2 | 2021-10-02 13:05:32 +0900 |
# >> |  84 |       1 |       2 | 2021-10-02 13:05:34 +0900 |
# >> |  85 |       1 |       2 | 2021-10-02 13:06:27 +0900 |
# >> |  86 |       1 |       2 | 2021-10-02 13:06:28 +0900 |
# >> |  87 |       1 |       2 | 2021-10-02 13:07:35 +0900 |
# >> |  88 |       1 |       2 | 2021-10-02 13:07:36 +0900 |
# >> |  89 |       1 |       2 | 2021-10-02 13:09:04 +0900 |
# >> |  90 |       1 |       2 | 2021-10-02 13:09:06 +0900 |
# >> |  91 |       1 |       2 | 2021-10-02 13:09:36 +0900 |
# >> |  92 |       1 |       2 | 2021-10-02 13:09:43 +0900 |
# >> |  93 |       1 |       2 | 2021-10-02 13:10:40 +0900 |
# >> |  94 |       1 |       2 | 2021-10-02 13:10:42 +0900 |
# >> |  95 |       1 |       2 | 2021-10-02 13:11:22 +0900 |
# >> |  96 |       1 |       2 | 2021-10-02 13:11:23 +0900 |
# >> |  97 |       1 |       2 | 2021-10-02 13:12:04 +0900 |
# >> |  98 |       1 |       2 | 2021-10-02 13:12:10 +0900 |
# >> |  99 |       1 |       2 | 2021-10-02 13:12:12 +0900 |
# >> | 100 |       1 |       2 | 2021-10-02 13:12:14 +0900 |
# >> | 101 |       1 |       2 | 2021-10-02 13:14:56 +0900 |
# >> | 102 |       1 |       2 | 2021-10-02 13:14:58 +0900 |
# >> | 103 |       1 |       2 | 2021-10-02 13:17:05 +0900 |
# >> | 104 |       1 |       2 | 2021-10-02 13:17:06 +0900 |
# >> | 105 |       1 |       2 | 2021-10-02 13:17:35 +0900 |
# >> | 106 |       1 |       2 | 2021-10-02 13:17:56 +0900 |
# >> | 107 |       1 |       2 | 2021-10-02 13:18:16 +0900 |
# >> | 108 |       1 |       2 | 2021-10-02 13:18:18 +0900 |
# >> | 109 |       1 |       2 | 2021-10-02 13:18:45 +0900 |
# >> | 110 |       1 |       2 | 2021-10-02 13:18:46 +0900 |
# >> | 111 |       1 |       2 | 2021-10-02 13:18:48 +0900 |
# >> | 112 |       1 |       2 | 2021-10-02 13:19:16 +0900 |
# >> | 113 |       1 |       2 | 2021-10-02 13:19:17 +0900 |
# >> | 114 |       1 |       2 | 2021-10-02 13:19:59 +0900 |
# >> | 115 |       1 |       2 | 2021-10-02 13:20:01 +0900 |
# >> | 116 |       1 |       2 | 2021-10-02 13:21:35 +0900 |
# >> | 117 |       1 |       2 | 2021-10-02 13:21:37 +0900 |
# >> | 118 |       1 |       2 | 2021-10-02 13:29:26 +0900 |
# >> | 119 |       1 |       2 | 2021-10-02 13:29:28 +0900 |
# >> | 120 |       1 |       2 | 2021-10-02 13:33:07 +0900 |
# >> | 121 |       1 |       2 | 2021-10-02 13:33:08 +0900 |
# >> | 122 |       1 |       2 | 2021-10-02 13:33:38 +0900 |
# >> | 123 |       1 |       2 | 2021-10-02 13:33:40 +0900 |
# >> | 124 |       1 |       2 | 2021-10-02 13:36:02 +0900 |
# >> | 125 |       1 |       2 | 2021-10-02 13:36:07 +0900 |
# >> | 126 |       1 |      11 | 2021-10-02 13:56:43 +0900 |
# >> |-----+---------+---------+---------------------------|
# >> |---------------------+----------------------------------------------|
# >> |                  id | 4                                            |
# >> |                 key | WbtOrG8oW0Z                                  |
# >> |             user_id | 1                                            |
# >> |           folder_id | 3                                            |
# >> |            lemon_id | 4                                            |
# >> |               title | タイトル4タイトル4タイトル4タイトル4         |
# >> |         description | descriptiondescriptiondescriptiondescription |
# >> |       thumbnail_pos | 0.0                                          |
# >> | book_messages_count | 0                                            |
# >> |   access_logs_count | 1                                            |
# >> |          created_at | 2021-10-02 10:47:45 +0900                    |
# >> |          updated_at | 2021-10-02 10:47:45 +0900                    |
# >> |            tag_list |                                              |
# >> |---------------------+----------------------------------------------|
# >> |----+-------------+---------+-----------+----------+------------------------------------------+----------------------------------------------+---------------+---------------------+-------------------+---------------------------+---------------------------+----------|
# >> | id | key         | user_id | folder_id | lemon_id | title                                    | description                                  | thumbnail_pos | book_messages_count | access_logs_count | created_at                | updated_at                | tag_list |
# >> |----+-------------+---------+-----------+----------+------------------------------------------+----------------------------------------------+---------------+---------------------+-------------------+---------------------------+---------------------------+----------|
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  1 | UC4gW1YaAD3 |       1 |         3 |        1 | タイトル1タイトル1タイトル1タイトル1     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                34 | 2021-10-02 10:35:34 +0900 | 2021-10-02 10:35:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  2 | HKuambTnfln |       1 |         3 |        2 | タイトル2タイトル2タイトル2タイトル2     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                81 | 2021-10-02 10:39:34 +0900 | 2021-10-02 10:39:34 +0900 |          |
# >> |  4 | WbtOrG8oW0Z |       1 |         3 |        4 | タイトル4タイトル4タイトル4タイトル4     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                 1 | 2021-10-02 10:47:45 +0900 | 2021-10-02 10:47:45 +0900 |          |
# >> |  5 | TC4rutOzF7n |       1 |         3 |        5 | タイトル5タイトル5タイトル5タイトル5     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                 1 | 2021-10-02 10:49:15 +0900 | 2021-10-02 10:49:15 +0900 |          |
# >> |  6 | WM9Ae28fQQX |       1 |         3 |        6 | タイトル6タイトル6タイトル6タイトル6     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                 1 | 2021-10-02 10:53:20 +0900 | 2021-10-02 10:53:20 +0900 |          |
# >> |  7 | hjVXihkqTcK |       1 |         3 |        7 | タイトル7タイトル7タイトル7タイトル7     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                 1 | 2021-10-02 10:56:39 +0900 | 2021-10-02 10:56:39 +0900 |          |
# >> |  8 | H9Hgl4xcXb2 |       1 |         3 |        8 | タイトル8タイトル8タイトル8タイトル8     | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                 1 | 2021-10-02 10:58:40 +0900 | 2021-10-02 10:58:40 +0900 |          |
# >> |  9 | Ta5LGhsm25T |       1 |         3 |        9 | タイトル9タイトル9タイトル9タイトル9     | descriptiondescriptiondescriptiondescription |           0.0 |                   3 |                 1 | 2021-10-02 11:01:17 +0900 | 2021-10-02 11:01:17 +0900 |          |
# >> | 10 | XRWneiXxsdg |       1 |         3 |       10 | タイトル10タイトル10タイトル10タイトル10 | descriptiondescriptiondescriptiondescription |           0.0 |                   3 |                 1 | 2021-10-02 11:35:10 +0900 | 2021-10-02 11:35:10 +0900 |          |
# >> | 11 | qrkyCoIPgIo |       1 |         1 |       11 | タイトル11タイトル11タイトル11タイトル11 | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                 1 | 2021-10-02 13:56:43 +0900 | 2021-10-02 13:56:43 +0900 |          |
# >> |----+-------------+---------+-----------+----------+------------------------------------------+----------------------------------------------+---------------+---------------------+-------------------+---------------------------+---------------------------+----------|
# >> |----+---------+---------+------------+---------------------------+---------------------------|
# >> | id | user_id | book_id | body       | created_at                | updated_at                |
# >> |----+---------+---------+------------+---------------------------+---------------------------|
# >> |  1 |       1 |       9 | (message1) | 2021-10-02 11:01:17 +0900 | 2021-10-02 11:01:17 +0900 |
# >> |  2 |       1 |       9 | (message1) | 2021-10-02 11:01:17 +0900 | 2021-10-02 11:01:17 +0900 |
# >> |  3 |       1 |       9 | (message1) | 2021-10-02 11:01:17 +0900 | 2021-10-02 11:01:17 +0900 |
# >> |  4 |       1 |      10 | (message1) | 2021-10-02 11:35:10 +0900 | 2021-10-02 11:35:10 +0900 |
# >> |  5 |       1 |      10 | (message1) | 2021-10-02 11:35:10 +0900 | 2021-10-02 11:35:10 +0900 |
# >> |  6 |       1 |      10 | (message1) | 2021-10-02 11:35:10 +0900 | 2021-10-02 11:35:10 +0900 |
# >> |  7 |       1 |      11 | (message1) | 2021-10-02 13:56:43 +0900 | 2021-10-02 13:56:43 +0900 |
# >> |  8 |       1 |      11 | (message1) | 2021-10-02 13:56:43 +0900 | 2021-10-02 13:56:43 +0900 |
# >> |  9 |       1 |      11 | (message1) | 2021-10-02 13:56:43 +0900 | 2021-10-02 13:56:43 +0900 |
# >> |----+---------+---------+------------+---------------------------+---------------------------|
# >>   Kiwi::BookMessage Load (0.5ms)  SELECT `kiwi_book_messages`.* FROM `kiwi_book_messages` WHERE `kiwi_book_messages`.`book_id` = 11
