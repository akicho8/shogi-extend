require "./setup"
Wkbk::Article.import_all(user: User.find(12))
# >> load: /Users/ikeda/src/shogi-extend/app/models/wkbk/articles.yml (321)
