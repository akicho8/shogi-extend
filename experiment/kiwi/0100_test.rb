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
lemon1.browser_path                # => "/system/x-files/06/70/12_20210925113024_1200x630_3s.mp4"
lemon1.real_path                   # => #<Pathname:/Users/ikeda/src/shogi-extend/public/system/x-files/06/70/12_20210925113024_1200x630_3s.mp4>
lemon1.thumbnail_browser_path.to_s # => "/system/x-files/06/70/12_20210925113024_1200x630_3s_thumbnail.png"
lemon1.thumbnail_real_path.to_s    # => "/Users/ikeda/src/shogi-extend/public/system/x-files/06/70/12_20210925113024_1200x630_3s_thumbnail.png"
tp lemon1

book1 = user1.kiwi_books.create!(lemon: lemon1)
tp book1 # => #<Kiwi::Book id: 10, key: "Li0gk83vMTr", user_id: 1, folder_id: 3, lemon_id: 12, title: "Li0gk83vMTr", description: "(description)", created_at: "2021-09-25 11:30:31.962949000 +0900", updated_at: "2021-09-25 11:30:31.962949000 +0900", tag_list: nil>
# >> |--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                 id | 92                                                                                                                                                                   |
# >> |                key | 067092c0181a7974f656afa0953997f3                                                                                                                                     |
# >> |              title |                                                                                                                                                                      |
# >> |          kifu_body | position startpos moves 7g7f 8c8d                                                                                                                                    |
# >> |          sfen_body | position startpos moves 7g7f 8c8d                                                                                                                                    |
# >> |           turn_max | 2                                                                                                                                                                    |
# >> |          meta_info | {:black=>{:defense=>[], :attack=>[], :technique=>[], :note=>[:居飛車, :相居飛車]}, :white=>{:defense=>[], :attack=>[], :technique=>[], :note=>[:居飛車, :相居飛車]}} |
# >> |         battled_at | 0001-01-01 00:00:00 +0918                                                                                                                                            |
# >> |            use_key | kiwi_lemon                                                                                                                                                           |
# >> |        accessed_at | 2021-09-25 11:30:23 +0900                                                                                                                                            |
# >> |            user_id | 1                                                                                                                                                                    |
# >> |         preset_key | 平手                                                                                                                                                                 |
# >> |        description |                                                                                                                                                                      |
# >> |          sfen_hash | f7625f17e18fa9af278c5f81287d933e                                                                                                                                     |
# >> |         start_turn |                                                                                                                                                                      |
# >> |      critical_turn |                                                                                                                                                                      |
# >> |      outbreak_turn |                                                                                                                                                                      |
# >> |         image_turn |                                                                                                                                                                      |
# >> |         created_at | 2021-09-25 11:30:24 +0900                                                                                                                                            |
# >> |         updated_at | 2021-09-25 11:30:24 +0900                                                                                                                                            |
# >> |   defense_tag_list |                                                                                                                                                                      |
# >> |    attack_tag_list |                                                                                                                                                                      |
# >> | technique_tag_list |                                                                                                                                                                      |
# >> |      note_tag_list |                                                                                                                                                                      |
# >> |     other_tag_list |                                                                                                                                                                      |
# >> |--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |               id | 12                                                                                                                                                                                                                                                                  |
# >> |          user_id | 1                                                                                                                                                                                                                                                                   |
# >> |  recordable_type | FreeBattle                                                                                                                                                                                                                                                          |
# >> |    recordable_id | 92                                                                                                                                                                                                                                                                  |
# >> |       all_params | {:media_builder_params=>{:recipe_key=>"is_recipe_mp4", :audio_theme_key=>"audio_theme_is_none", :color_theme_key=>"color_theme_is_real_wood1", :renderer_override_params=>{}}}                                                                                      |
# >> | process_begin_at | 2021-09-25 11:30:24 +0900                                                                                                                                                                                                                                           |
# >> |   process_end_at | 2021-09-25 11:30:31 +0900                                                                                                                                                                                                                                           |
# >> |     successed_at | 2021-09-25 11:30:31 +0900                                                                                                                                                                                                                                           |
# >> |       errored_at |                                                                                                                                                                                                                                                                     |
# >> |    error_message |                                                                                                                                                                                                                                                                     |
# >> |        file_size | 115509                                                                                                                                                                                                                                                              |
# >> |     ffprobe_info | {:pretty_format=>{"streams"=>[{"index"=>0, "codec_name"=>"h264", "codec_long_name"=>"H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10", "profile"=>"High", "codec_type"=>"video", "codec_tag_string"=>"avc1", "codec_tag"=>"0x31637661", "width"=>1200, "height"=>630, ... |
# >> |     browser_path | /system/x-files/06/70/12_20210925113024_1200x630_3s.mp4                                                                                                                                                                                                             |
# >> |   filename_human | 12_20210925113024_1200x630_3s.mp4                                                                                                                                                                                                                                   |
# >> |       created_at | 2021-09-25 11:30:24 +0900                                                                                                                                                                                                                                           |
# >> |       updated_at | 2021-09-25 11:30:31 +0900                                                                                                                                                                                                                                           |
# >> |------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |-------------+---------------------------|
# >> |          id | 10                        |
# >> |         key | Li0gk83vMTr               |
# >> |     user_id | 1                         |
# >> |   folder_id | 3                         |
# >> |    lemon_id | 12                        |
# >> |       title | Li0gk83vMTr               |
# >> | description | (description)             |
# >> |  created_at | 2021-09-25 11:30:31 +0900 |
# >> |  updated_at | 2021-09-25 11:30:31 +0900 |
# >> |    tag_list |                           |
# >> |-------------+---------------------------|
