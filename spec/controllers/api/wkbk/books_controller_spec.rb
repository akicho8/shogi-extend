# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Book (wkbk_books as Wkbk::Book)
#
# |-------------------+-------------------+-------------+---------------------+------+-------|
# | name              | desc              | type        | opts                | refs | index |
# |-------------------+-------------------+-------------+---------------------+------+-------|
# | id                | ID                | integer(8)  | NOT NULL PK         |      |       |
# | key               | キー              | string(255) | NOT NULL            |      | A!    |
# | user_id           | User              | integer(8)  | NOT NULL            |      | B     |
# | folder_id         | Folder            | integer(8)  | NOT NULL            |      | C     |
# | sequence_id       | Sequence          | integer(8)  | NOT NULL            |      | D     |
# | title             | タイトル          | string(100) | NOT NULL            |      |       |
# | description       | 説明              | text(65535) | NOT NULL            |      |       |
# | bookships_count   | Bookships count   | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | answer_logs_count | Answer logs count | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | created_at        | 作成日時          | datetime    | NOT NULL            |      |       |
# | updated_at        | 更新日時          | datetime    | NOT NULL            |      |       |
# | access_logs_count | Access logs count | integer(4)  | DEFAULT(0) NOT NULL |      | E     |
# |-------------------+-------------------+-------------+---------------------+------+-------|
#
# - Remarks ----------------------------------------------------------------------
# [Warning: Need to add relation] Wkbk::Book モデルに belongs_to :sequence を追加しよう
# [Warning: Need to add relation] Wkbk::Book モデルに belongs_to :user を追加しよう
# --------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe Api::Wkbk::BooksController, type: :controller do
  include WkbkSupportMethods
  [
    { action: :index, params: {},               status: 200, },
    { action: :show,  params: { book_key: 1,    },               status: 200, },
    { action: :show,  params: { book_key: 2,    },               status: 403, },
    { action: :show,  params: { book_key: :x,   },               status: 404, },
    { action: :edit,  params: { book_key: 2,    }, user: :admin, status: 200, },
    { action: :show,  params: { book_key: 4,    }, user: :admin, status: 403, },
    { action: :edit,  params: {},               status: 403, },
    { action: :edit,  params: {}, user: :admin, status: 200, },
    { action: :edit,  params: {},               status: 403, },
    { action: :edit,  params: {}, user: :admin, status: 200, },
    { action: :edit,  params: { book_key: 1,    },               status: 403, },
    { action: :edit,  params: { book_key: 2,    },               status: 403, },
    { action: :edit,  params: { book_key: 3,    },               status: 403, },
    { action: :edit,  params: { book_key: 4,    },               status: 403, },
    { action: :edit,  params: { book_key: 1,    }, user: :admin, status: 200, },
    { action: :edit,  params: { book_key: 2,    }, user: :admin, status: 200, },
    { action: :edit,  params: { book_key: 3,    }, user: :admin, status: 404, },
    { action: :edit,  params: { book_key: 4,    }, user: :admin, status: 404, },
  ].each do |e|
    it "アクセス制限" do
      if e[:user]
        user_login(User.admin)
      end
      get e[:action], params: e[:params]
      assert { response.status == e[:status] }
    end
  end
end
