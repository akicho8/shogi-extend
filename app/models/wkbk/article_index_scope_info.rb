module Wkbk
  class ArticleIndexScopeInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :everyone, name: "全体",   query_func: -> user { Article.where(book: Book.public_only)                                                                            } },
      { key: :public,   name: "公開",   query_func: -> user { user ? user.wkbk_articles.where(book: user.wkbk_books.public_only) : Article.none                                          } },
      { key: :private,  name: "非公開", query_func: -> user { user ? user.wkbk_articles.where(book: user.wkbk_books.private_only).or(user.wkbk_articles.where(book: nil)) : Article.none } },
    ]
  end
end
