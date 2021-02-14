module Wkbk
  class BookIndexScopeInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :everyone, name: "全体",   query_func: -> user { Book.public_only                                } },
      { key: :public,   name: "公開",   query_func: -> user { user ? user.wkbk_books.public_only : Book.none  } },
      { key: :private,  name: "非公開", query_func: -> user { user ? user.wkbk_books.private_only : Book.none } },
    ]
  end
end
