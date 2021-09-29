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
lemon1.browser_path                # => "/system/x-files/b1/57/4_20210930082812_1200x630_4s.mp4"
lemon1.real_path                   # => #<Pathname:/Users/ikeda/src/shogi-extend/public/system/x-files/b1/57/4_20210930082812_1200x630_4s.mp4>
lemon1.thumbnail_browser_path.to_s # => "/system/x-files/b1/57/4_20210930082812_1200x630_4s_thumbnail.png"
lemon1.thumbnail_real_path.to_s    # => "/Users/ikeda/src/shogi-extend/public/system/x-files/b1/57/4_20210930082812_1200x630_4s_thumbnail.png"
tp lemon1

# フォーム初期値
book1 = user1.kiwi_books.build(lemon: lemon1)
book1.form_values_default_assign
exit
tp book1.attributes

book1 = user1.kiwi_books.create!(lemon: lemon1, title: "タイトル#{user1.kiwi_books.count.next}" * 4, description: "description" * 4, tag_list: %w(居飛車 嬉野流 右玉))

tp book1 # => 
lemon1.book # => 

book1.book_messages.create!(user: user1, body: "(message1)")      # => 
user1.kiwi_book_messages.create!(book: book1, body: "(message1)") # => 
user1.kiwi_book_message_speak(book1, "(message1)")                # => 

tp user1.kiwi_book_messages

ActiveSupport::LogSubscriber.colorize_logging = false
logger = ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)

book1.book_messages.to_a

ActiveRecord::Base.logger = logger

# >> |--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                 id | 25                                                                                                                                                                   |
# >> |                key | b157db05f9e51f3d0a465fd0c6dcde16                                                                                                                                     |
# >> |              title |                                                                                                                                                                      |
# >> |          kifu_body | position startpos moves 7g7f 8c8d                                                                                                                                    |
# >> |          sfen_body | position startpos moves 7g7f 8c8d                                                                                                                                    |
# >> |           turn_max | 2                                                                                                                                                                    |
# >> |          meta_info | {:black=>{:defense=>[], :attack=>[], :technique=>[], :note=>[:居飛車, :相居飛車]}, :white=>{:defense=>[], :attack=>[], :technique=>[], :note=>[:居飛車, :相居飛車]}} |
# >> |         battled_at | 0001-01-01 00:00:00 +0918                                                                                                                                            |
# >> |            use_key | kiwi_lemon                                                                                                                                                           |
# >> |        accessed_at | 2021-09-30 08:28:11 +0900                                                                                                                                            |
# >> |            user_id | 1                                                                                                                                                                    |
# >> |         preset_key | 平手                                                                                                                                                                 |
# >> |        description |                                                                                                                                                                      |
# >> |          sfen_hash | f7625f17e18fa9af278c5f81287d933e                                                                                                                                     |
# >> |         start_turn |                                                                                                                                                                      |
# >> |      critical_turn |                                                                                                                                                                      |
# >> |      outbreak_turn |                                                                                                                                                                      |
# >> |         image_turn |                                                                                                                                                                      |
# >> |         created_at | 2021-09-30 08:28:12 +0900                                                                                                                                            |
# >> |         updated_at | 2021-09-30 08:28:12 +0900                                                                                                                                            |
# >> |   defense_tag_list |                                                                                                                                                                      |
# >> |    attack_tag_list |                                                                                                                                                                      |
# >> | technique_tag_list |                                                                                                                                                                      |
# >> |      note_tag_list |                                                                                                                                                                      |
# >> |     other_tag_list |                                                                                                                                                                      |
# >> |--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |               id | 4                                                                                                                                                                                                                                                                   |
# >> |          user_id | 1                                                                                                                                                                                                                                                                   |
# >> |  recordable_type | FreeBattle                                                                                                                                                                                                                                                          |
# >> |    recordable_id | 25                                                                                                                                                                                                                                                                  |
# >> |       all_params | {:media_builder_params=>{:recipe_key=>"is_recipe_mp4", :audio_theme_key=>"audio_theme_is_none", :color_theme_key=>"color_theme_is_real_wood1", :cover_text=>"(cover_text.title)\n(cover_text.description)", :renderer_override_params=>{}}}                         |
# >> | process_begin_at | 2021-09-30 08:28:12 +0900                                                                                                                                                                                                                                           |
# >> |   process_end_at | 2021-09-30 08:28:21 +0900                                                                                                                                                                                                                                           |
# >> |     successed_at | 2021-09-30 08:28:21 +0900                                                                                                                                                                                                                                           |
# >> |       errored_at |                                                                                                                                                                                                                                                                     |
# >> |    error_message |                                                                                                                                                                                                                                                                     |
# >> |        file_size | 135006                                                                                                                                                                                                                                                              |
# >> |     ffprobe_info | {:pretty_format=>{"streams"=>[{"index"=>0, "codec_name"=>"h264", "codec_long_name"=>"H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10", "profile"=>"High", "codec_type"=>"video", "codec_tag_string"=>"avc1", "codec_tag"=>"0x31637661", "width"=>1200, "height"=>630, ... |
# >> |     browser_path | /system/x-files/b1/57/4_20210930082812_1200x630_4s.mp4                                                                                                                                                                                                              |
# >> |   filename_human | 4_20210930082812_1200x630_4s.mp4                                                                                                                                                                                                                                    |
# >> |       created_at | 2021-09-30 08:28:12 +0900                                                                                                                                                                                                                                           |
# >> |       updated_at | 2021-09-30 08:28:21 +0900                                                                                                                                                                                                                                           |
# >> |------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> []
# >> ["居飛車", "相居飛車"]
