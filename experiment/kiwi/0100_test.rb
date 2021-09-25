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
lemon1.browser_path                # => "/system/x-files/d7/09/7_20210926082433_1200x630_4s.mp4"
lemon1.real_path                   # => #<Pathname:/Users/ikeda/src/shogi-extend/public/system/x-files/d7/09/7_20210926082433_1200x630_4s.mp4>
lemon1.thumbnail_browser_path.to_s # => "/system/x-files/d7/09/7_20210926082433_1200x630_4s_thumbnail.png"
lemon1.thumbnail_real_path.to_s    # => "/Users/ikeda/src/shogi-extend/public/system/x-files/d7/09/7_20210926082433_1200x630_4s_thumbnail.png"
tp lemon1

# フォーム初期値
book1 = user1.kiwi_books.build(lemon: lemon1)
book1.default_assign
tp book1.attributes

book1 = user1.kiwi_books.create!(lemon: lemon1, title: "タイトル#{user1.kiwi_books.count.next}" * 4, description: "description" * 4, tag_list: %w(居飛車 振り飛車 嬉野流 xaby角))

tp book1 # => #<Kiwi::Book id: 6, key: "GZV4as7JjaB", user_id: 1, folder_id: 3, lemon_id: 7, title: "タイトル6タイトル6タイトル6タイトル6", description: "descriptiondescriptiondescriptiondescription", created_at: "2021-09-26 08:24:40.937888000 +0900", updated_at: "2021-09-26 08:24:41.296132000 +0900", tag_list: ["居飛車", "振り飛車", "嬉野流", "xaby角"]>
lemon1.book                     # => #<Kiwi::Book id: 6, key: "GZV4as7JjaB", user_id: 1, folder_id: 3, lemon_id: 7, title: "タイトル6タイトル6タイトル6タイトル6", description: "descriptiondescriptiondescriptiondescription", created_at: "2021-09-26 08:24:40.937888000 +0900", updated_at: "2021-09-26 08:24:41.296132000 +0900", tag_list: ["居飛車", "振り飛車", "嬉野流", "xaby角"]>

# >> |--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                 id | 104                                                                                                                                                                  |
# >> |                key | d709209de603411be5495c776aefd7f6                                                                                                                                     |
# >> |              title |                                                                                                                                                                      |
# >> |          kifu_body | position startpos moves 7g7f 8c8d                                                                                                                                    |
# >> |          sfen_body | position startpos moves 7g7f 8c8d                                                                                                                                    |
# >> |           turn_max | 2                                                                                                                                                                    |
# >> |          meta_info | {:black=>{:defense=>[], :attack=>[], :technique=>[], :note=>[:居飛車, :相居飛車]}, :white=>{:defense=>[], :attack=>[], :technique=>[], :note=>[:居飛車, :相居飛車]}} |
# >> |         battled_at | 0001-01-01 00:00:00 +0918                                                                                                                                            |
# >> |            use_key | kiwi_lemon                                                                                                                                                           |
# >> |        accessed_at | 2021-09-26 08:24:32 +0900                                                                                                                                            |
# >> |            user_id | 1                                                                                                                                                                    |
# >> |         preset_key | 平手                                                                                                                                                                 |
# >> |        description |                                                                                                                                                                      |
# >> |          sfen_hash | f7625f17e18fa9af278c5f81287d933e                                                                                                                                     |
# >> |         start_turn |                                                                                                                                                                      |
# >> |      critical_turn |                                                                                                                                                                      |
# >> |      outbreak_turn |                                                                                                                                                                      |
# >> |         image_turn |                                                                                                                                                                      |
# >> |         created_at | 2021-09-26 08:24:33 +0900                                                                                                                                            |
# >> |         updated_at | 2021-09-26 08:24:33 +0900                                                                                                                                            |
# >> |   defense_tag_list |                                                                                                                                                                      |
# >> |    attack_tag_list |                                                                                                                                                                      |
# >> | technique_tag_list |                                                                                                                                                                      |
# >> |      note_tag_list |                                                                                                                                                                      |
# >> |     other_tag_list |                                                                                                                                                                      |
# >> |--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |               id | 7                                                                                                                                                                                                                                                                   |
# >> |          user_id | 1                                                                                                                                                                                                                                                                   |
# >> |  recordable_type | FreeBattle                                                                                                                                                                                                                                                          |
# >> |    recordable_id | 104                                                                                                                                                                                                                                                                 |
# >> |       all_params | {:media_builder_params=>{:recipe_key=>"is_recipe_mp4", :audio_theme_key=>"audio_theme_is_none", :color_theme_key=>"color_theme_is_real_wood1", :cover_text=>"(cover_text.title)\n(cover_text.description)", :renderer_override_params=>{}}}                         |
# >> | process_begin_at | 2021-09-26 08:24:33 +0900                                                                                                                                                                                                                                           |
# >> |   process_end_at | 2021-09-26 08:24:40 +0900                                                                                                                                                                                                                                           |
# >> |     successed_at | 2021-09-26 08:24:40 +0900                                                                                                                                                                                                                                           |
# >> |       errored_at |                                                                                                                                                                                                                                                                     |
# >> |    error_message |                                                                                                                                                                                                                                                                     |
# >> |        file_size | 135006                                                                                                                                                                                                                                                              |
# >> |     ffprobe_info | {:pretty_format=>{"streams"=>[{"index"=>0, "codec_name"=>"h264", "codec_long_name"=>"H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10", "profile"=>"High", "codec_type"=>"video", "codec_tag_string"=>"avc1", "codec_tag"=>"0x31637661", "width"=>1200, "height"=>630, ... |
# >> |     browser_path | /system/x-files/d7/09/7_20210926082433_1200x630_4s.mp4                                                                                                                                                                                                              |
# >> |   filename_human | 7_20210926082433_1200x630_4s.mp4                                                                                                                                                                                                                                    |
# >> |       created_at | 2021-09-26 08:24:33 +0900                                                                                                                                                                                                                                           |
# >> |       updated_at | 2021-09-26 08:24:40 +0900                                                                                                                                                                                                                                           |
# >> |------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> {:media_builder_params=>
# >>   {:recipe_key=>"is_recipe_mp4",
# >>    :audio_theme_key=>"audio_theme_is_none",
# >>    :color_theme_key=>"color_theme_is_real_wood1",
# >>    :cover_text=>"(cover_text.title)\n" + "(cover_text.description)",
# >>    :renderer_override_params=>{}}}
# >> |-------------+--------------------------|
# >> |          id |                          |
# >> |         key |                          |
# >> |     user_id | 1                        |
# >> |   folder_id |                          |
# >> |    lemon_id | 7                        |
# >> |       title | (cover_text.title)\n     |
# >> | description | (cover_text.description) |
# >> |  created_at |                          |
# >> |  updated_at |                          |
# >> |    tag_list |                          |
# >> |-------------+--------------------------|
# >> |-------------+----------------------------------------------|
# >> |          id | 6                                            |
# >> |         key | GZV4as7JjaB                                  |
# >> |     user_id | 1                                            |
# >> |   folder_id | 3                                            |
# >> |    lemon_id | 7                                            |
# >> |       title | タイトル6タイトル6タイトル6タイトル6         |
# >> | description | descriptiondescriptiondescriptiondescription |
# >> |  created_at | 2021-09-26 08:24:40 +0900                    |
# >> |  updated_at | 2021-09-26 08:24:41 +0900                    |
# >> |    tag_list | 居飛車 振り飛車 嬉野流 xaby角                |
# >> |-------------+----------------------------------------------|
