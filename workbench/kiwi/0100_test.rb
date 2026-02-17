require "./setup"

Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

Kiwi::Banana.destroy_all
Kiwi::Lemon.destroy_all
Kiwi::Folder.setup

user1 = User.admin
params1 = {
  :body => "position startpos moves 7g7f 8c8d",
  :all_params => {
    :media_builder_params => {
      :tmpdir_remove   => false,
      :recipe_key      => "is_recipe_gif",
      :audio_theme_key => "is_audio_theme_none",
      :color_theme_key => "is_color_theme_real",
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
lemon1.browser_path                # => "/system/x-files/04/2a/32_20211003154247_1200x630_4s.gif"
lemon1.real_path                   # => #<Pathname:/Users/ikeda/src/shogi/shogi-extend/public/system/x-files/04/2a/32_20211003154247_1200x630_4s.gif>
lemon1.thumbnail_browser_path.to_s # => ""
lemon1.thumbnail_real_path.to_s    # => ""
tp lemon1

# フォーム初期値
banana1 = user1.kiwi_bananas.build(lemon: lemon1) # => #<Kiwi::Banana id: nil, key: nil, user_id: 1, folder_id: nil, lemon_id: 32, title: nil, description: nil, thumbnail_pos: nil, banana_messages_count: 0, access_logs_count: 0, created_at: nil, updated_at: nil, tag_list: nil>
banana1.form_values_default_assign
tp banana1.attributes             # => {"id"=>nil, "key"=>nil, "user_id"=>1, "folder_id"=>nil, "lemon_id"=>32, "title"=>"(cover_text.title)", "description"=>"(cover_text.description)", "thumbnail_pos"=>0.0, "banana_messages_count"=>0, "access_logs_count"=>0, "created_at"=>nil, "updated_at"=>nil, "tag_list"=>["居飛車", "相居飛車"]}
banana1.lemon                     # => #<Kiwi::Lemon id: 32, user_id: 1, recordable_type: "FreeBattle", recordable_id: 54, all_params: {:media_builder_params=>{:tmpdir_remove=>false, :recipe_key=>"is_recipe_gif", :audio_theme_key=>"is_audio_theme_none", :color_theme_key=>"is_color_theme_real", :cover_text=>"(cover_text.title)\n(cover_text.description)", :renderer_override_params=>{}}}, process_begin_at: "2021-10-03 15:42:47.000000000 +0900", process_end_at: "2021-10-03 15:42:53.000000000 +0900", successed_at: "2021-10-03 15:42:53.000000000 +0900", errored_at: nil, error_message: nil, content_type: "image/gif", file_size: 331740, ffprobe_info: {:pretty_format=>{"streams"=>[{"index"=>0, "codec_name"=>"gif", "codec_long_name"=>"CompuServe GIF (Graphics Interchange Format)", "codec_type"=>"video", "codec_tag_string"=>"[0][0][0][0]", "codec_tag"=>"0x0000", "width"=>1200, "height"=>630, "coded_width"=>1200, "coded_height"=>630, "closed_captions"=>0, "has_b_frames"=>0, "pix_fmt"=>"bgra", "level"=>-99, "refs"=>1, "r_frame_rate"=>"1/1", "avg_frame_rate"=>"1/1", "time_base"=>"1/100", "start_pts"=>0, "start_time"=>"0:00:00.000000", "duration_ts"=>400, "duration"=>"0:00:04.000000", "nb_frames"=>"4", "disposition"=>{"default"=>0, "dub"=>0, "original"=>0, "comment"=>0, "lyrics"=>0, "karaoke"=>0, "forced"=>0, "hearing_impaired"=>0, "visual_impaired"=>0, "clean_effects"=>0, "attached_pic"=>0, "timed_thumbnails"=>0}}]}, :direct_format=>{"streams"=>[{"index"=>0, "codec_name"=>"gif", "codec_long_name"=>"CompuServe GIF (Graphics Interchange Format)", "codec_type"=>"video", "codec_tag_string"=>"[0][0][0][0]", "codec_tag"=>"0x0000", "width"=>1200, "height"=>630, "coded_width"=>1200, "coded_height"=>630, "closed_captions"=>0, "has_b_frames"=>0, "pix_fmt"=>"bgra", "level"=>-99, "refs"=>1, "r_frame_rate"=>"1/1", "avg_frame_rate"=>"1/1", "time_base"=>"1/100", "start_pts"=>0, "start_time"=>"0.000000", "duration_ts"=>400, "duration"=>"4.000000", "nb_frames"=>"4", "disposition"=>{"default"=>0, "dub"=>0, "original"=>0, "comment"=>0, "lyrics"=>0, "karaoke"=>0, "forced"=>0, "hearing_impaired"=>0, "visual_impaired"=>0, "clean_effects"=>0, "attached_pic"=>0, "timed_thumbnails"=>0}}]}}, browser_path: "/system/x-files/04/2a/32_20211003154247_1200x630_4...", filename_human: "32_20211003154247_1200x630_4s.gif", created_at: "2021-10-03 15:42:47.143975000 +0900", updated_at: "2021-10-03 15:42:53.194957000 +0900">

banana1 = user1.kiwi_bananas.create!(lemon: lemon1, folder_key: "public", title: "タイトル#{user1.kiwi_bananas.count.next}" * 4, description: "description" * 4, tag_list: %w[居飛車 嬉野流 右玉])
banana1.thumbnail_pos                 # => 0.0
lemon1.thumbnail_real_path      # => nil
lemon1.thumbnail_browser_path   # => nil
tp banana1 # => #<Kiwi::Banana id: 32, key: "C4Y6yaXeJUK", user_id: 1, folder_id: 1, lemon_id: 32, title: "タイトル1タイトル1タイトル1タイトル1", description: "descriptiondescriptiondescriptiondescription", thumbnail_pos: 0.0, banana_messages_count: 0, access_logs_count: 0, created_at: "2021-10-03 15:42:53.271123000 +0900", updated_at: "2021-10-03 15:42:53.271123000 +0900", tag_list: ["居飛車", "嬉野流", "右玉"]>
lemon1.banana # => #<Kiwi::Banana id: 32, key: "C4Y6yaXeJUK", user_id: 1, folder_id: 1, lemon_id: 32, title: "タイトル1タイトル1タイトル1タイトル1", description: "descriptiondescriptiondescriptiondescription", thumbnail_pos: 0.0, banana_messages_count: 0, access_logs_count: 0, created_at: "2021-10-03 15:42:53.271123000 +0900", updated_at: "2021-10-03 15:42:53.271123000 +0900", tag_list: ["居飛車", "嬉野流", "右玉"]>

# アクセスログ
banana1.access_logs.create!(user: user1) # => #<Kiwi::AccessLog id: 44, user_id: 1, banana_id: 32, created_at: "2021-10-03 15:42:53.000000000 +0900">
tp user1.kiwi_access_logs                 # => #<ActiveRecord::Associations::CollectionProxy [#<Kiwi::AccessLog id: 44, user_id: 1, banana_id: 32, created_at: "2021-10-03 15:42:53.000000000 +0900">]>
tp user1.kiwi_access_logs.first.banana      # => #<Kiwi::Banana id: 32, key: "C4Y6yaXeJUK", user_id: 1, folder_id: 1, lemon_id: 32, title: "タイトル1タイトル1タイトル1タイトル1", description: "descriptiondescriptiondescriptiondescription", thumbnail_pos: 0.0, banana_messages_count: 0, access_logs_count: 1, created_at: "2021-10-03 15:42:53.271123000 +0900", updated_at: "2021-10-03 15:42:53.271123000 +0900", tag_list: nil>
tp user1.kiwi_access_bananas                 # => #<ActiveRecord::Associations::CollectionProxy [#<Kiwi::Banana id: 32, key: "C4Y6yaXeJUK", user_id: 1, folder_id: 1, lemon_id: 32, title: "タイトル1タイトル1タイトル1タイトル1", description: "descriptiondescriptiondescriptiondescription", thumbnail_pos: 0.0, banana_messages_count: 0, access_logs_count: 1, created_at: "2021-10-03 15:42:53.271123000 +0900", updated_at: "2021-10-03 15:42:53.271123000 +0900", tag_list: nil>]>

# コメント
banana1.banana_messages.create!(user: user1, body: "(message1)")      # => #<Kiwi::BananaMessage id: 66, user_id: 1, banana_id: 32, body: "(message1)", position: 1, deleted_at: nil, created_at: "2021-10-03 15:42:53.319801000 +0900", updated_at: "2021-10-03 15:42:53.319801000 +0900">
user1.kiwi_banana_messages.create!(banana: banana1, body: "(message1)") # => #<Kiwi::BananaMessage id: 67, user_id: 1, banana_id: 32, body: "(message1)", position: 2, deleted_at: nil, created_at: "2021-10-03 15:42:53.331886000 +0900", updated_at: "2021-10-03 15:42:53.331886000 +0900">
user1.kiwi_banana_message_speak(banana1, "(message1)")                # => #<Kiwi::BananaMessage id: 68, user_id: 1, banana_id: 32, body: "(message1)", position: 3, deleted_at: nil, created_at: "2021-10-03 15:42:53.345906000 +0900", updated_at: "2021-10-03 15:42:53.345906000 +0900">

tp user1.kiwi_banana_messages

# >> |--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                 id | 54                                                                                                                                                                   |
# >> |                key | 042a368bba058799f1384c5fdfb4233b                                                                                                                                     |
# >> |              title |                                                                                                                                                                      |
# >> |          kifu_body | position startpos moves 7g7f 8c8d                                                                                                                                    |
# >> |          sfen_body | position startpos moves 7g7f 8c8d                                                                                                                                    |
# >> |           turn_max | 2                                                                                                                                                                    |
# >> |          meta_info | {:black=>{:defense=>[], :attack=>[], :technique=>[], :note=>[:居飛車, :相居飛車]}, :white=>{:defense=>[], :attack=>[], :technique=>[], :note=>[:居飛車, :相居飛車]}} |
# >> |         battled_at | 0001-01-01 00:00:00 +0918                                                                                                                                            |
# >> |            use_key | kiwi_lemon                                                                                                                                                           |
# >> |        accessed_at | 2021-10-03 15:42:46 +0900                                                                                                                                            |
# >> |            user_id | 1                                                                                                                                                                    |
# >> |         preset_key | 平手                                                                                                                                                                 |
# >> |        description |                                                                                                                                                                      |
# >> |          sfen_hash | f7625f17e18fa9af278c5f81287d933e                                                                                                                                     |
# >> |         start_turn |                                                                                                                                                                      |
# >> |      critical_turn |                                                                                                                                                                      |
# >> |      outbreak_turn |                                                                                                                                                                      |
# >> |         image_turn |                                                                                                                                                                      |
# >> |         created_at | 2021-10-03 15:42:47 +0900                                                                                                                                            |
# >> |         updated_at | 2021-10-03 15:42:47 +0900                                                                                                                                            |
# >> |   defense_tag_list |                                                                                                                                                                      |
# >> |    attack_tag_list |                                                                                                                                                                      |
# >> | technique_tag_list |                                                                                                                                                                      |
# >> |      note_tag_list |                                                                                                                                                                      |
# >> |     other_tag_list |                                                                                                                                                                      |
# >> |--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> [AnimationGifBuilder] cd /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gn/T/d20211003-73350-r5zeye
# >> [AnimationGifBuilder] 生成に使うもの: ffmpeg
# >> [AnimationGifBuilder] 最後に追加するフレーム数(end_pages): 0
# >> [AnimationGifBuilder] 1手当たりの秒数(page_duration): 1.0
# >> [AnimationGifBuilder] 2021-10-03 15:42:49 1/5  20.00 % T1 表紙描画
# >> [AnimationGifBuilder] [表紙描画][begin]
# >> [AnimationGifBuilder] [表紙描画][end][0s]
# >> [AnimationGifBuilder] 2021-10-03 15:42:49 2/5  40.00 % T0 初期配置
# >> [AnimationGifBuilder] [初期配置][begin]
# >> [AnimationGifBuilder] [0] static layer
# >> [AnimationGifBuilder] [0] canvas_layer_create for s_canvas_layer
# >> [AnimationGifBuilder] [0] transparent_layer create for s_board_layer BEGIN
# >> [AnimationGifBuilder] [0] transparent_layer create for s_board_layer END
# >> [AnimationGifBuilder] [0] transparent_layer create for s_lattice_layer BEGIN
# >> [AnimationGifBuilder] [0] transparent_layer create for s_lattice_layer END
# >> [AnimationGifBuilder] [0] dynamic layer
# >> [AnimationGifBuilder] [0] transparent_layer create for d_move_layer BEGIN
# >> [AnimationGifBuilder] [0] transparent_layer create for d_move_layer END
# >> [AnimationGifBuilder] [0] transparent_layer create for d_piece_layer BEGIN
# >> [AnimationGifBuilder] [0] transparent_layer create for d_piece_layer END
# >> [AnimationGifBuilder] [0] transparent_layer create for d_piece_count_layer BEGIN
# >> [AnimationGifBuilder] [0] transparent_layer create for d_piece_count_layer END
# >> [AnimationGifBuilder] [0] composite process
# >> [AnimationGifBuilder] [初期配置][end][1s]
# >> [AnimationGifBuilder] 2021-10-03 15:42:50 3/5  60.00 % T1 (0/2) 7g7f
# >> [AnimationGifBuilder] [0/2][begin]
# >> [AnimationGifBuilder] [1] static layer
# >> [AnimationGifBuilder] [1] dynamic layer
# >> [AnimationGifBuilder] [1] transparent_layer create for d_move_layer BEGIN
# >> [AnimationGifBuilder] [1] transparent_layer create for d_move_layer END
# >> [AnimationGifBuilder] [1] transparent_layer create for d_piece_layer BEGIN
# >> [AnimationGifBuilder] [1] transparent_layer create for d_piece_layer END
# >> [AnimationGifBuilder] [1] transparent_layer create for d_piece_count_layer BEGIN
# >> [AnimationGifBuilder] [1] transparent_layer create for d_piece_count_layer END
# >> [AnimationGifBuilder] [1] composite process
# >> [AnimationGifBuilder] [0/2][end][1s]
# >> [AnimationGifBuilder] move: 0 / 2
# >> [AnimationGifBuilder] 2021-10-03 15:42:51 4/5  80.00 % T0 (1/2) 8c8d
# >> [AnimationGifBuilder] [1/2][begin]
# >> [AnimationGifBuilder] [2] static layer
# >> [AnimationGifBuilder] [2] dynamic layer
# >> [AnimationGifBuilder] [2] transparent_layer create for d_move_layer BEGIN
# >> [AnimationGifBuilder] [2] transparent_layer create for d_move_layer END
# >> [AnimationGifBuilder] [2] transparent_layer create for d_piece_layer BEGIN
# >> [AnimationGifBuilder] [2] transparent_layer create for d_piece_layer END
# >> [AnimationGifBuilder] [2] transparent_layer create for d_piece_count_layer BEGIN
# >> [AnimationGifBuilder] [2] transparent_layer create for d_piece_count_layer END
# >> [AnimationGifBuilder] [2] composite process
# >> [AnimationGifBuilder] [1/2][end][1s]
# >> [AnimationGifBuilder] 2021-10-03 15:42:52 5/5 100.00 % T1 gif 生成 4p
# >> [AnimationGifBuilder] ページ数: 4, 存在ファイル数: 4, ファイル名: _input%04d.png
# >> [AnimationGifBuilder] ソース画像確認
# >> -rw-r--r-- 1 ikeda staff  25K 10  3 15:42 _input0000.png
# >> -rw-r--r-- 1 ikeda staff 396K 10  3 15:42 _input0001.png
# >> -rw-r--r-- 1 ikeda staff 400K 10  3 15:42 _input0002.png
# >> -rw-r--r-- 1 ikeda staff 404K 10  3 15:42 _input0003.png
# >>
# >> [AnimationGifBuilder] [execute] ffmpeg -v warning -hide_banner -framerate 10000/10000.0 -i _input%04d.png  -y _output1.gif
# >> [AnimationGifBuilder] [execute] elapsed: 1s
# >> [AnimationGifBuilder] -rw-r--r-- 1 ikeda staff 324K 10  3 15:42 _output1.gif
# >> [AnimationGifBuilder] [clear_all] @s_canvas_layer.destroy!
# >> [AnimationGifBuilder] [clear_all] @s_board_layer.destroy!
# >> [AnimationGifBuilder] [clear_all] @s_lattice_layer.destroy!
# >> [AnimationGifBuilder] [clear_all] @d_move_layer.destroy!
# >> [AnimationGifBuilder] [clear_all] @d_piece_layer.destroy!
# >> [AnimationGifBuilder] [clear_all] @d_piece_count_layer.destroy!
# >> [AnimationGifBuilder] [clear_all] @last_rendered_image.destroy!
# >> |------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |               id | 32                                                                                                                                                                                                                                                                  |
# >> |          user_id | 1                                                                                                                                                                                                                                                                   |
# >> |  recordable_type | FreeBattle                                                                                                                                                                                                                                                          |
# >> |    recordable_id | 54                                                                                                                                                                                                                                                                  |
# >> |       all_params | {:media_builder_params=>{:tmpdir_remove=>false, :recipe_key=>"is_recipe_gif", :audio_theme_key=>"is_audio_theme_none", :color_theme_key=>"is_color_theme_real", :cover_text=>"(cover_text.title)\n(cover_text.description)", :renderer_override_params=>{}... |
# >> | process_begin_at | 2021-10-03 15:42:47 +0900                                                                                                                                                                                                                                           |
# >> |   process_end_at | 2021-10-03 15:42:53 +0900                                                                                                                                                                                                                                           |
# >> |     successed_at | 2021-10-03 15:42:53 +0900                                                                                                                                                                                                                                           |
# >> |       errored_at |                                                                                                                                                                                                                                                                     |
# >> |    error_message |                                                                                                                                                                                                                                                                     |
# >> |     content_type | image/gif                                                                                                                                                                                                                                                           |
# >> |        file_size | 331740                                                                                                                                                                                                                                                              |
# >> |     ffprobe_info | {:pretty_format=>{"streams"=>[{"index"=>0, "codec_name"=>"gif", "codec_long_name"=>"CompuServe GIF (Graphics Interchange Format)", "codec_type"=>"video", "codec_tag_string"=>"[0][0][0][0]", "codec_tag"=>"0x0000", "width"=>1200, "height"=>630, "coded_width"... |
# >> |     browser_path | /system/x-files/04/2a/32_20211003154247_1200x630_4s.gif                                                                                                                                                                                                             |
# >> |   filename_human | 32_20211003154247_1200x630_4s.gif                                                                                                                                                                                                                                   |
# >> |       created_at | 2021-10-03 15:42:47 +0900                                                                                                                                                                                                                                           |
# >> |       updated_at | 2021-10-03 15:42:53 +0900                                                                                                                                                                                                                                           |
# >> |------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |---------------------+--------------------------|
# >> |                  id |                          |
# >> |                 key |                          |
# >> |             user_id | 1                        |
# >> |           folder_id |                          |
# >> |            lemon_id | 32                       |
# >> |               title | (cover_text.title)       |
# >> |         description | (cover_text.description) |
# >> |       thumbnail_pos | 0.0                      |
# >> | banana_messages_count | 0                        |
# >> |   access_logs_count | 0                        |
# >> |          created_at |                          |
# >> |          updated_at |                          |
# >> |            tag_list | 居飛車 相居飛車          |
# >> |---------------------+--------------------------|
# >> |---------------------+----------------------------------------------|
# >> |                  id | 32                                           |
# >> |                 key | C4Y6yaXeJUK                                  |
# >> |             user_id | 1                                            |
# >> |           folder_id | 1                                            |
# >> |            lemon_id | 32                                           |
# >> |               title | タイトル1タイトル1タイトル1タイトル1         |
# >> |         description | descriptiondescriptiondescriptiondescription |
# >> |       thumbnail_pos | 0.0                                          |
# >> | banana_messages_count | 0                                            |
# >> |   access_logs_count | 0                                            |
# >> |          created_at | 2021-10-03 15:42:53 +0900                    |
# >> |          updated_at | 2021-10-03 15:42:53 +0900                    |
# >> |            tag_list | 居飛車 嬉野流 右玉                           |
# >> |---------------------+----------------------------------------------|
# >> |----+---------+---------+---------------------------|
# >> | id | user_id | banana_id | created_at                |
# >> |----+---------+---------+---------------------------|
# >> | 44 |       1 |      32 | 2021-10-03 15:42:53 +0900 |
# >> |----+---------+---------+---------------------------|
# >> |---------------------+----------------------------------------------|
# >> |                  id | 32                                           |
# >> |                 key | C4Y6yaXeJUK                                  |
# >> |             user_id | 1                                            |
# >> |           folder_id | 1                                            |
# >> |            lemon_id | 32                                           |
# >> |               title | タイトル1タイトル1タイトル1タイトル1         |
# >> |         description | descriptiondescriptiondescriptiondescription |
# >> |       thumbnail_pos | 0.0                                          |
# >> | banana_messages_count | 0                                            |
# >> |   access_logs_count | 1                                            |
# >> |          created_at | 2021-10-03 15:42:53 +0900                    |
# >> |          updated_at | 2021-10-03 15:42:53 +0900                    |
# >> |            tag_list |                                              |
# >> |---------------------+----------------------------------------------|
# >> |----+-------------+---------+-----------+----------+--------------------------------------+----------------------------------------------+---------------+---------------------+-------------------+---------------------------+---------------------------+----------|
# >> | id | key         | user_id | folder_id | lemon_id | title                                | description                                  | thumbnail_pos | banana_messages_count | access_logs_count | created_at                | updated_at                | tag_list |
# >> |----+-------------+---------+-----------+----------+--------------------------------------+----------------------------------------------+---------------+---------------------+-------------------+---------------------------+---------------------------+----------|
# >> | 32 | C4Y6yaXeJUK |       1 |         1 |       32 | タイトル1タイトル1タイトル1タイトル1 | descriptiondescriptiondescriptiondescription |           0.0 |                   0 |                 1 | 2021-10-03 15:42:53 +0900 | 2021-10-03 15:42:53 +0900 |          |
# >> |----+-------------+---------+-----------+----------+--------------------------------------+----------------------------------------------+---------------+---------------------+-------------------+---------------------------+---------------------------+----------|
# >> |----+---------+---------+------------+----------+------------+---------------------------+---------------------------|
# >> | id | user_id | banana_id | body       | position | deleted_at | created_at                | updated_at                |
# >> |----+---------+---------+------------+----------+------------+---------------------------+---------------------------|
# >> | 66 |       1 |      32 | (message1) |        1 |            | 2021-10-03 15:42:53 +0900 | 2021-10-03 15:42:53 +0900 |
# >> | 67 |       1 |      32 | (message1) |        2 |            | 2021-10-03 15:42:53 +0900 | 2021-10-03 15:42:53 +0900 |
# >> | 68 |       1 |      32 | (message1) |        3 |            | 2021-10-03 15:42:53 +0900 | 2021-10-03 15:42:53 +0900 |
# >> |----+---------+---------+------------+----------+------------+---------------------------+---------------------------|
