require "./setup"

require "./setup"

Wkbk::Article.destroy_all

user1 = User.create!
user2 = User.create!

article1 = user1.wkbk_articles.create_mock1
article1.messages.create!(user: user1, body: "message") # => #<Wkbk::ArticleMessage id: 28, user_id: 140, article_id: 58, body: "message", created_at: "2020-06-25 06:50:49", updated_at: "2020-06-25 06:50:49">
