require "./setup"
Wkbk::Article.import_all(user: User.find(12))
