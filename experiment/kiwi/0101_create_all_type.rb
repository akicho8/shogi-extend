require "./setup"

Kiwi::Folder.setup
Kiwi::Book.destroy_all

def create(recipe_key)
  recipe_info = RecipeInfo.fetch(recipe_key)
  user1 = User.sysop
  params1 = {
    :body => "position startpos moves 7g7f 8c8d",
    :all_params => {
      :media_builder_params => {
        :recipe_key      => recipe_info.key,
        :audio_theme_key => "audio_theme_is_none",
        :color_theme_key => "color_theme_is_real_wood1",
        :cover_text      => "(cover_text.title)\n(cover_text.description)",
      },
    },
  }
  free_battle = user1.free_battles.create!(kifu_body: params1[:body], use_key: "kiwi_lemon")
  lemon1 = user1.kiwi_lemons.create!(recordable: free_battle, all_params: params1[:all_params])
  lemon1.main_process
  book1 = user1.kiwi_books.create!(lemon: lemon1, title: "#{user1.name} - #{recipe_info.name}(#{user1.kiwi_books.count.next})", description: "あいうえお" * 40, tag_list: %w(居飛車 嬉野流 右玉), folder_key: "public")
  book1.book_messages.create!(user: user1, body: "#{recipe_info.name}に対するコメント")
  puts recipe_info
end

create("is_recipe_mp4")
create("is_recipe_gif")
create("is_recipe_apng")
create("is_recipe_webp")
create("is_recipe_png")
create("is_recipe_zip")

tp Kiwi.info
# >> |-------------------+-------+--------|
# >> | model             | count | 最終ID |
# >> |-------------------+-------+--------|
# >> | User              |     4 |      4 |
# >> | Kiwi::BookMessage |     4 |     65 |
# >> | Kiwi::Book        |     4 |     52 |
# >> | Kiwi::Lemon       |    24 |     58 |
# >> | Kiwi::Folder      |     3 |      3 |
# >> |-------------------+-------+--------|
