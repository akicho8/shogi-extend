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
lemon1.main_process!
lemon1.reload
lemon1.status_key                  # => "成功"
lemon1.browser_path                # => "/system/x-files/9d/47/8_20210926164131_1200x630_4s.mp4"
lemon1.real_path                   # => #<Pathname:/Users/ikeda/src/shogi-extend/public/system/x-files/9d/47/8_20210926164131_1200x630_4s.mp4>
lemon1.thumbnail_browser_path.to_s # => "/system/x-files/9d/47/8_20210926164131_1200x630_4s_thumbnail.png"
lemon1.thumbnail_real_path.to_s    # => "/Users/ikeda/src/shogi-extend/public/system/x-files/9d/47/8_20210926164131_1200x630_4s_thumbnail.png"
tp lemon1

# フォーム初期値
book1 = user1.kiwi_books.build(lemon: lemon1)
book1.default_assign
tp book1.attributes

book1 = user1.kiwi_books.create!(lemon: lemon1, title: "タイトル#{user1.kiwi_books.count.next}" * 4, description: "description" * 4, tag_list: %w(居飛車 振り飛車 嬉野流 xaby角))

tp book1 # => #<Kiwi::Book id: 8, key: "Gi9m1q25I82", user_id: 1, folder_id: 3, lemon_id: 8, title: "タイトル8タイトル8タイトル8タイトル8", description: "descriptiondescriptiondescriptiondescription", book_messages_count: 0, created_at: "2021-09-26 16:41:39.834729000 +0900", updated_at: "2021-09-26 16:41:39.834729000 +0900", tag_list: ["居飛車", "振り飛車", "嬉野流", "xaby角"]>
lemon1.book                     # => #<Kiwi::Book id: 8, key: "Gi9m1q25I82", user_id: 1, folder_id: 3, lemon_id: 8, title: "タイトル8タイトル8タイトル8タイトル8", description: "descriptiondescriptiondescriptiondescription", book_messages_count: 0, created_at: "2021-09-26 16:41:39.834729000 +0900", updated_at: "2021-09-26 16:41:39.834729000 +0900", tag_list: ["居飛車", "振り飛車", "嬉野流", "xaby角"]>

book1.book_messages.create!(user: user1, body: "(message1)")      # => #<Kiwi::BookMessage id: 34, user_id: 1, book_id: 8, body: "(message1)", created_at: "2021-09-26 16:41:39.904285000 +0900", updated_at: "2021-09-26 16:41:39.904285000 +0900">
user1.kiwi_book_messages.create!(book: book1, body: "(message1)") # => #<Kiwi::BookMessage id: 35, user_id: 1, book_id: 8, body: "(message1)", created_at: "2021-09-26 16:41:39.915013000 +0900", updated_at: "2021-09-26 16:41:39.915013000 +0900">
user1.kiwi_book_message_speak(book1, "(message1)")                # => #<Kiwi::BookMessage id: 36, user_id: 1, book_id: 8, body: "(message1)", created_at: "2021-09-26 16:41:39.922599000 +0900", updated_at: "2021-09-26 16:41:39.922599000 +0900">

tp user1.kiwi_book_messages

ActiveSupport::LogSubscriber.colorize_logging = false
logger = ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)

book1.book_messages.to_a
# >>   Kiwi::BookMessage Load (0.4ms)  SELECT `kiwi_book_messages`.* FROM `kiwi_book_messages` WHERE `kiwi_book_messages`.`book_id` = 8

ActiveRecord::Base.logger = logger



# >> |--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                 id | 128                                                                                                                                                                  |
# >> |                key | 9d47cf7fc244c0e52a920f79e5dbf64e                                                                                                                                     |
# >> |              title |                                                                                                                                                                      |
# >> |          kifu_body | position startpos moves 7g7f 8c8d                                                                                                                                    |
# >> |          sfen_body | position startpos moves 7g7f 8c8d                                                                                                                                    |
# >> |           turn_max | 2                                                                                                                                                                    |
# >> |          meta_info | {:black=>{:defense=>[], :attack=>[], :technique=>[], :note=>[:居飛車, :相居飛車]}, :white=>{:defense=>[], :attack=>[], :technique=>[], :note=>[:居飛車, :相居飛車]}} |
# >> |         battled_at | 0001-01-01 00:00:00 +0918                                                                                                                                            |
# >> |            use_key | kiwi_lemon                                                                                                                                                           |
# >> |        accessed_at | 2021-09-26 16:41:30 +0900                                                                                                                                            |
# >> |            user_id | 1                                                                                                                                                                    |
# >> |         preset_key | 平手                                                                                                                                                                 |
# >> |        description |                                                                                                                                                                      |
# >> |          sfen_hash | f7625f17e18fa9af278c5f81287d933e                                                                                                                                     |
# >> |         start_turn |                                                                                                                                                                      |
# >> |      critical_turn |                                                                                                                                                                      |
# >> |      outbreak_turn |                                                                                                                                                                      |
# >> |         image_turn |                                                                                                                                                                      |
# >> |         created_at | 2021-09-26 16:41:30 +0900                                                                                                                                            |
# >> |         updated_at | 2021-09-26 16:41:30 +0900                                                                                                                                            |
# >> |   defense_tag_list |                                                                                                                                                                      |
# >> |    attack_tag_list |                                                                                                                                                                      |
# >> | technique_tag_list |                                                                                                                                                                      |
# >> |      note_tag_list |                                                                                                                                                                      |
# >> |     other_tag_list |                                                                                                                                                                      |
# >> |--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |               id | 8                                                                                                                                                                                                                                                                   |
# >> |          user_id | 1                                                                                                                                                                                                                                                                   |
# >> |  recordable_type | FreeBattle                                                                                                                                                                                                                                                          |
# >> |    recordable_id | 128                                                                                                                                                                                                                                                                 |
# >> |       all_params | {:media_builder_params=>{:recipe_key=>"is_recipe_mp4", :audio_theme_key=>"audio_theme_is_none", :color_theme_key=>"color_theme_is_real_wood1", :cover_text=>"(cover_text.title)\n(cover_text.description)", :renderer_override_params=>{}}}                         |
# >> | process_begin_at | 2021-09-26 16:41:31 +0900                                                                                                                                                                                                                                           |
# >> |   process_end_at | 2021-09-26 16:41:39 +0900                                                                                                                                                                                                                                           |
# >> |     successed_at | 2021-09-26 16:41:39 +0900                                                                                                                                                                                                                                           |
# >> |       errored_at |                                                                                                                                                                                                                                                                     |
# >> |    error_message |                                                                                                                                                                                                                                                                     |
# >> |        file_size | 135006                                                                                                                                                                                                                                                              |
# >> |     ffprobe_info | {:pretty_format=>{"streams"=>[{"index"=>0, "codec_name"=>"h264", "codec_long_name"=>"H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10", "profile"=>"High", "codec_type"=>"video", "codec_tag_string"=>"avc1", "codec_tag"=>"0x31637661", "width"=>1200, "height"=>630, ... |
# >> |     browser_path | /system/x-files/9d/47/8_20210926164131_1200x630_4s.mp4                                                                                                                                                                                                              |
# >> |   filename_human | 8_20210926164131_1200x630_4s.mp4                                                                                                                                                                                                                                    |
# >> |       created_at | 2021-09-26 16:41:31 +0900                                                                                                                                                                                                                                           |
# >> |       updated_at | 2021-09-26 16:41:39 +0900                                                                                                                                                                                                                                           |
# >> |------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |---------------------+----------------------------|
# >> |                  id |                            |
# >> |                 key |                            |
# >> |             user_id | 1                          |
# >> |           folder_id |                            |
# >> |            lemon_id | 8                          |
# >> |               title | (cover_text.title)         |
# >> |         description | (cover_text.description)\n |
# >> | book_messages_count | 0                          |
# >> |          created_at |                            |
# >> |          updated_at |                            |
# >> |            tag_list |                            |
# >> |---------------------+----------------------------|
# >> |---------------------+----------------------------------------------|
# >> |                  id | 8                                            |
# >> |                 key | Gi9m1q25I82                                  |
# >> |             user_id | 1                                            |
# >> |           folder_id | 3                                            |
# >> |            lemon_id | 8                                            |
# >> |               title | タイトル8タイトル8タイトル8タイトル8         |
# >> |         description | descriptiondescriptiondescriptiondescription |
# >> | book_messages_count | 0                                            |
# >> |          created_at | 2021-09-26 16:41:39 +0900                    |
# >> |          updated_at | 2021-09-26 16:41:39 +0900                    |
# >> |            tag_list | 居飛車 振り飛車 嬉野流 xaby角                |
# >> |---------------------+----------------------------------------------|
# >> |----+---------+---------+------------+---------------------------+---------------------------|
# >> | id | user_id | book_id | body       | created_at                | updated_at                |
# >> |----+---------+---------+------------+---------------------------+---------------------------|
# >> |  2 |       1 |       2 | (message1) | 2021-09-26 15:07:26 +0900 | 2021-09-26 15:07:26 +0900 |
# >> |  3 |       1 |       3 | (message1) | 2021-09-26 15:07:50 +0900 | 2021-09-26 15:07:50 +0900 |
# >> |  4 |       1 |       4 | (message1) | 2021-09-26 15:13:51 +0900 | 2021-09-26 15:13:51 +0900 |
# >> |  5 |       1 |       4 | (message1) | 2021-09-26 15:13:51 +0900 | 2021-09-26 15:13:51 +0900 |
# >> |  6 |       1 |       5 | (message1) | 2021-09-26 15:17:21 +0900 | 2021-09-26 15:17:21 +0900 |
# >> |  7 |       1 |       5 | (message1) | 2021-09-26 15:17:22 +0900 | 2021-09-26 15:17:22 +0900 |
# >> |  8 |       1 |       6 | (message1) | 2021-09-26 15:17:53 +0900 | 2021-09-26 15:17:53 +0900 |
# >> |  9 |       1 |       6 | (message1) | 2021-09-26 15:17:53 +0900 | 2021-09-26 15:17:53 +0900 |
# >> | 10 |       1 |       6 | (message1) | 2021-09-26 15:17:53 +0900 | 2021-09-26 15:17:53 +0900 |
# >> | 11 |       1 |       7 | (message1) | 2021-09-26 15:19:28 +0900 | 2021-09-26 15:19:28 +0900 |
# >> | 12 |       1 |       7 | (message1) | 2021-09-26 15:19:28 +0900 | 2021-09-26 15:19:28 +0900 |
# >> | 13 |       1 |       7 | (message1) | 2021-09-26 15:19:28 +0900 | 2021-09-26 15:19:28 +0900 |
# >> | 14 |       1 |       7 | a          | 2021-09-26 16:26:38 +0900 | 2021-09-26 16:26:38 +0900 |
# >> | 15 |       1 |       7 | b          | 2021-09-26 16:26:41 +0900 | 2021-09-26 16:26:41 +0900 |
# >> | 16 |       1 |       7 | c          | 2021-09-26 16:26:44 +0900 | 2021-09-26 16:26:44 +0900 |
# >> | 17 |       1 |       7 | aaa        | 2021-09-26 16:26:49 +0900 | 2021-09-26 16:26:49 +0900 |
# >> | 18 |       1 |       7 | http://aa  | 2021-09-26 16:26:57 +0900 | 2021-09-26 16:26:57 +0900 |
# >> | 19 |       1 |       7 | あいうえお | 2021-09-26 16:27:07 +0900 | 2021-09-26 16:27:07 +0900 |
# >> | 20 |       1 |       7 | それは     | 2021-09-26 16:27:12 +0900 | 2021-09-26 16:27:12 +0900 |
# >> | 21 |       1 |       7 | どうなん？ | 2021-09-26 16:27:16 +0900 | 2021-09-26 16:27:16 +0900 |
# >> | 22 |       1 |       7 | ok         | 2021-09-26 16:31:12 +0900 | 2021-09-26 16:31:12 +0900 |
# >> | 23 |       1 |       7 | abc        | 2021-09-26 16:31:17 +0900 | 2021-09-26 16:31:17 +0900 |
# >> | 24 |       1 |       7 | aaa        | 2021-09-26 16:31:19 +0900 | 2021-09-26 16:31:19 +0900 |
# >> | 25 |       1 |       7 | abc        | 2021-09-26 16:31:23 +0900 | 2021-09-26 16:31:23 +0900 |
# >> | 26 |       1 |       7 | aaaa       | 2021-09-26 16:31:26 +0900 | 2021-09-26 16:31:26 +0900 |
# >> | 27 |       1 |       7 | aaa        | 2021-09-26 16:31:28 +0900 | 2021-09-26 16:31:28 +0900 |
# >> | 28 |       1 |       7 | aaa        | 2021-09-26 16:31:41 +0900 | 2021-09-26 16:31:41 +0900 |
# >> | 29 |       1 |       7 | aaa        | 2021-09-26 16:31:48 +0900 | 2021-09-26 16:31:48 +0900 |
# >> | 30 |       1 |       7 | aaa        | 2021-09-26 16:31:50 +0900 | 2021-09-26 16:31:50 +0900 |
# >> | 31 |       1 |       7 | b          | 2021-09-26 16:31:53 +0900 | 2021-09-26 16:31:53 +0900 |
# >> | 32 |       1 |       7 | c          | 2021-09-26 16:31:55 +0900 | 2021-09-26 16:31:55 +0900 |
# >> | 33 |       1 |       7 | d          | 2021-09-26 16:31:56 +0900 | 2021-09-26 16:31:56 +0900 |
# >> | 34 |       1 |       8 | (message1) | 2021-09-26 16:41:39 +0900 | 2021-09-26 16:41:39 +0900 |
# >> | 35 |       1 |       8 | (message1) | 2021-09-26 16:41:39 +0900 | 2021-09-26 16:41:39 +0900 |
# >> | 36 |       1 |       8 | (message1) | 2021-09-26 16:41:39 +0900 | 2021-09-26 16:41:39 +0900 |
# >> |----+---------+---------+------------+---------------------------+---------------------------|
# >>   Kiwi::BookMessage Load (0.4ms)  SELECT `kiwi_book_messages`.* FROM `kiwi_book_messages` WHERE `kiwi_book_messages`.`book_id` = 8
