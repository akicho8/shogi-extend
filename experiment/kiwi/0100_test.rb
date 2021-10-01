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
lemon1.status_key                  # => 
lemon1.browser_path                # => 
lemon1.real_path                   # => 
lemon1.thumbnail_browser_path.to_s # => 
lemon1.thumbnail_real_path.to_s    # => 
tp lemon1

# フォーム初期値
book1 = user1.kiwi_books.build(lemon: lemon1) # => 
book1.form_values_default_assign
tp book1.attributes             # => 
book1.lemon                     # => 

book1 = user1.kiwi_books.create!(lemon: lemon1, title: "タイトル#{user1.kiwi_books.count.next}" * 4, description: "description" * 4, tag_list: %w(居飛車 嬉野流 右玉))
book1.thumbnail_pos                 # => 
lemon1.thumbnail_real_path      # => 
lemon1.thumbnail_browser_path   # => 
book1.avatar_path               # => 
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

# ~> /Users/ikeda/src/shogi-extend/app/models/kiwi/lemon/thumbnail_methods.rb:15:in `thumbnail_real_path': undefined method `match?' for nil:NilClass (NoMethodError)
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/kiwi/lemon/thumbnail_methods.rb:23:in `thumbnail_browser_path'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activemodel-6.1.4/lib/active_model/serialization.rb:138:in `block in serializable_hash'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activemodel-6.1.4/lib/active_model/serialization.rb:138:in `each'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activemodel-6.1.4/lib/active_model/serialization.rb:138:in `serializable_hash'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.1.4/lib/active_record/serialization.rb:21:in `serializable_hash'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activemodel-6.1.4/lib/active_model/serializers/json.rb:103:in `as_json'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.1.4/lib/active_support/core_ext/object/json.rb:154:in `block in as_json'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.1.4/lib/active_support/core_ext/object/json.rb:154:in `map'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.1.4/lib/active_support/core_ext/object/json.rb:154:in `as_json'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.1.4/lib/active_record/relation/delegation.rb:88:in `as_json'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/kiwi/user_methods.rb:29:in `kiwi_my_lemons_singlecast'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/kiwi/lemon/build_methods.rb:143:in `block in main_process'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.1.4/lib/active_support/tagged_logging.rb:99:in `block in tagged'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.1.4/lib/active_support/tagged_logging.rb:37:in `tagged'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.1.4/lib/active_support/tagged_logging.rb:99:in `tagged'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/kiwi/lemon/build_methods.rb:139:in `main_process'
# ~> 	from -:24:in `<main>'
# >> |--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                 id | 61                                                                                                                                                                   |
# >> |                key | 3672178ac75677d652283956a15f50a9                                                                                                                                     |
# >> |              title |                                                                                                                                                                      |
# >> |          kifu_body | position startpos moves 7g7f 8c8d                                                                                                                                    |
# >> |          sfen_body | position startpos moves 7g7f 8c8d                                                                                                                                    |
# >> |           turn_max | 2                                                                                                                                                                    |
# >> |          meta_info | {:black=>{:defense=>[], :attack=>[], :technique=>[], :note=>[:居飛車, :相居飛車]}, :white=>{:defense=>[], :attack=>[], :technique=>[], :note=>[:居飛車, :相居飛車]}} |
# >> |         battled_at | 0001-01-01 00:00:00 +0918                                                                                                                                            |
# >> |            use_key | kiwi_lemon                                                                                                                                                           |
# >> |        accessed_at | 2021-10-01 17:22:57 +0900                                                                                                                                            |
# >> |            user_id | 1                                                                                                                                                                    |
# >> |         preset_key | 平手                                                                                                                                                                 |
# >> |        description |                                                                                                                                                                      |
# >> |          sfen_hash | f7625f17e18fa9af278c5f81287d933e                                                                                                                                     |
# >> |         start_turn |                                                                                                                                                                      |
# >> |      critical_turn |                                                                                                                                                                      |
# >> |      outbreak_turn |                                                                                                                                                                      |
# >> |         image_turn |                                                                                                                                                                      |
# >> |         created_at | 2021-10-01 17:22:57 +0900                                                                                                                                            |
# >> |         updated_at | 2021-10-01 17:22:57 +0900                                                                                                                                            |
# >> |   defense_tag_list |                                                                                                                                                                      |
# >> |    attack_tag_list |                                                                                                                                                                      |
# >> | technique_tag_list |                                                                                                                                                                      |
# >> |      note_tag_list |                                                                                                                                                                      |
# >> |     other_tag_list |                                                                                                                                                                      |
# >> |--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
