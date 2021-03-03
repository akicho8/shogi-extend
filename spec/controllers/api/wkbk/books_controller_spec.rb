# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Book (wkbk_books as Wkbk::Book)
#
# |-------------------+--------------------+-------------+---------------------+--------------+-------|
# | name              | desc               | type        | opts                | refs         | index |
# |-------------------+--------------------+-------------+---------------------+--------------+-------|
# | id                | ID                 | integer(8)  | NOT NULL PK         |              |       |
# | key               | ユニークなハッシュ | string(255) | NOT NULL            |              | A!    |
# | user_id           | User               | integer(8)  | NOT NULL            | => ::User#id | B     |
# | folder_id         | Folder             | integer(8)  | NOT NULL            |              | C     |
# | sequence_id       | Sequence           | integer(8)  | NOT NULL            |              | D     |
# | title             | タイトル           | string(100) | NOT NULL            |              |       |
# | description       | 説明               | text(65535) | NOT NULL            |              |       |
# | bookships_count   | Bookships count    | integer(4)  | DEFAULT(0) NOT NULL |              |       |
# | answer_logs_count | Answer logs count  | integer(4)  | DEFAULT(0) NOT NULL |              |       |
# | created_at        | 作成日時           | datetime    | NOT NULL            |              |       |
# | updated_at        | 更新日時           | datetime    | NOT NULL            |              |       |
# |-------------------+--------------------+-------------+---------------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

require 'rails_helper'

RSpec.describe Api::Wkbk::BooksController, type: :controller do
  before(:context) do
    Wkbk::Book.mock_setup
  end

  [
    { get: [ :index, params: {                 }, ],               status: 200, },
    { get: [ :show,  params: { book_key: 1,    }, ],               status: 200, },
    { get: [ :show,  params: { book_key: 2,    }, ],               status: 403, },
    { get: [ :show,  params: { book_key: :x,   }, ],               status: 404, },
    { get: [ :edit,  params: { book_key: 2,    }, ], user: :sysop, status: 200, },
    { get: [ :show,  params: { book_key: 4,    }, ], user: :sysop, status: 403, },
    { get: [ :edit,  params: {                 }, ],               status: 403, },
    { get: [ :edit,  params: {                 }, ], user: :sysop, status: 200, },
    { get: [ :edit,  params: {                 }, ],               status: 403, },
    { get: [ :edit,  params: {                 }, ], user: :sysop, status: 200, },
    { get: [ :edit,  params: { book_key: 1,    }, ],               status: 403, },
    { get: [ :edit,  params: { book_key: 2,    }, ],               status: 403, },
    { get: [ :edit,  params: { book_key: 3,    }, ],               status: 403, },
    { get: [ :edit,  params: { book_key: 4,    }, ],               status: 403, },
    { get: [ :edit,  params: { book_key: 1,    }, ], user: :sysop, status: 200, },
    { get: [ :edit,  params: { book_key: 2,    }, ], user: :sysop, status: 200, },
    { get: [ :edit,  params: { book_key: 3,    }, ], user: :sysop, status: 404, },
    { get: [ :edit,  params: { book_key: 4,    }, ], user: :sysop, status: 404, },
  ].each do |e|
    it "アクセス制限" do
      if e[:user]
        user_login(User.sysop)
      end
      get *e[:get]
      assert { response.status == e[:status] }
    end
  end
end
