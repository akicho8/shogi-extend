require "./setup"

Wkbk::Book.setup
tp Wkbk.info

exit






User.delete_all

Wkbk.destroy_all
Wkbk.setup

################################################################################

Wkbk::Folder.all.collect(&:key) # => 

Wkbk::Article.count          # => 
Wkbk::Book.count             # => 
Wkbk::Lineage.all.collect(&:key) # => 

user1 = User.sysop
user2 = User.find_or_create_by!(key: "alice")

User.setup

################################################################################

book = user1.wkbk_books.create! do |e|
  e.title = "アヒル戦法問題集"
  e.description = "説明文"
  e.folder_key = :public
end

book # => 

################################################################################

# 問題作成
10.times do |i|
  article = user1.wkbk_articles.create! do |e|
    e.moves_answer_validate_skip = true

    e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l#{i+1}p 1"
    e.moves_answers.build(moves_str: "G*4b")
    e.moves_answers.build(moves_str: "G*5b")
    e.moves_answers.build(moves_str: "G*6b")

    e.updated_at = Time.current - 1.days + i.hours

    e.title                 = "(title#{i})"
    e.description           = "(description)"
  end

  book.articles << article
end
Wkbk::Article.count           # => 
book.articles.count           # => 

article = Wkbk::Article.first!
article.lineage.key               # => 

tp Wkbk::Article
tp Wkbk.info

# >> |----------------------------+-------------------------------------------------|
# >> |                         id | 54                                              |
# >> |                        key | 9d7d6d0418d79128e13fa2276d11e871                |
# >> |                    user_id | 1                                               |
# >> |                 lineage_id | 1                                               |
# >> |                    book_id | 6                                               |
# >> |                  init_sfen | 7nl/7k1/9/7pp/6N2/9/9/9/9 b GS2r2b3g3s2n3l16p 1 |
# >> |                  viewpoint | black                                           |
# >> |                      title | ef3a052f33723d2a7694fe45fed9e846                |
# >> |                description |                                                 |
# >> |                   turn_max |                                                 |
# >> |                  mate_skip |                                                 |
# >> |          direction_message |                                                 |
# >> |        moves_answers_count | 0                                               |
# >> |                 created_at | 2021-01-28 21:06:06 +0900                       |
# >> |                 updated_at | 2021-01-28 21:06:06 +0900                       |
# >> | moves_answer_validate_skip |                                                 |
# >> |              user_tag_list |                                                 |
# >> |             owner_tag_list |                                                 |
# >> |----------------------------+-------------------------------------------------|
# >> |-------------------+-------+--------|
# >> | model             | count | 最終ID |
# >> |-------------------+-------+--------|
# >> | User              |     2 |      2 |
# >> | Wkbk::Folder      |     2 |      2 |
# >> | Wkbk::Lineage     |     8 |      8 |
# >> | Wkbk::Book        |     6 |      6 |
# >> | Wkbk::Article     |    54 |     54 |
# >> | Wkbk::MovesAnswer |   100 |    100 |
# >> |-------------------+-------+--------|
