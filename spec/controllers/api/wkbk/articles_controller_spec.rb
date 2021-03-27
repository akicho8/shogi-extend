# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Article (wkbk_articles as Wkbk::Article)
#
# |---------------------+---------------------+-------------+---------------------+--------------+-------|
# | name                | desc                | type        | opts                | refs         | index |
# |---------------------+---------------------+-------------+---------------------+--------------+-------|
# | id                  | ID                  | integer(8)  | NOT NULL PK         |              |       |
# | key                 | ユニークなハッシュ  | string(255) | NOT NULL            |              | A!    |
# | user_id             | User                | integer(8)  | NOT NULL            | => ::User#id | B     |
# | folder_id           | Folder              | integer(8)  | NOT NULL            |              | C     |
# | lineage_id          | Lineage             | integer(8)  | NOT NULL            |              | D     |
# | init_sfen           | Init sfen           | string(255) | NOT NULL            |              | E     |
# | viewpoint           | Viewpoint           | string(255) | NOT NULL            |              |       |
# | title               | タイトル            | string(100) | NOT NULL            |              |       |
# | description         | 説明                | text(65535) | NOT NULL            |              |       |
# | direction_message   | Direction message   | string(100) | NOT NULL            |              |       |
# | turn_max            | 手数                | integer(4)  | NOT NULL            |              | F     |
# | mate_skip           | Mate skip           | boolean     | NOT NULL            |              |       |
# | moves_answers_count | Moves answers count | integer(4)  | DEFAULT(0) NOT NULL |              |       |
# | difficulty          | Difficulty          | integer(4)  | NOT NULL            |              | G     |
# | answer_logs_count   | Answer logs count   | integer(4)  | DEFAULT(0) NOT NULL |              |       |
# | created_at          | 作成日時            | datetime    | NOT NULL            |              |       |
# | updated_at          | 更新日時            | datetime    | NOT NULL            |              |       |
# |---------------------+---------------------+-------------+---------------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

require 'rails_helper'

RSpec.describe Api::Wkbk::ArticlesController, type: :controller do
  include WkbkSupportMethods
  [
    { get: [ :index, params: {                  }],               status: 200, },
    { get: [ :edit,  params: {                  }],               status: 403, },
    { get: [ :edit,  params: {                  }], user: :sysop, status: 200, },
    { get: [ :show,  params: { article_key: 1,  }],               status: 200, },
    { get: [ :show,  params: { article_key: 2,  }],               status: 403, },
    { get: [ :show,  params: { article_key: :x, }],               status: 404, },
    { get: [ :show,  params: { article_key: 2,  }], user: :sysop, status: 200, },
    { get: [ :show,  params: { article_key: 4,  }], user: :sysop, status: 403, },
    { get: [ :edit,  params: { article_key: 1,  }],               status: 403, },
    { get: [ :edit,  params: { article_key: 1,  }], user: :sysop, status: 200, },
    { get: [ :edit,  params: { article_key: 2,  }],               status: 403, },
    { get: [ :edit,  params: { article_key: 2,  }], user: :sysop, status: 200, },
    { get: [ :edit,  params: { article_key: 3,  }],               status: 403, },
    { get: [ :edit,  params: { article_key: 3,  }], user: :sysop, status: 404, },
    { get: [ :edit,  params: { article_key: 4,  }],               status: 403, },
    { get: [ :edit,  params: { article_key: 4,  }], user: :sysop, status: 404, },
    { get: [ :edit,  params: { article_key: :x, }], user: :sysop, status: 404, },
  ].each do |e|
    it "アクセス制限" do
      if e[:user]
        user_login(User.sysop)
      end
      get *e[:get]
      assert { response.status == e[:status] }
    end
  end

  describe "new" do
    it "works" do
      user_login(User.sysop)
      get :edit, params: { tag_list: "a,b c", book_keys: "1,2" }
      info = JSON.parse(response.body)
      assert { info["article"]["tag_list"] == ["a", "b", "c"] }
      assert { info["books"].collect { |e| e["key"] } == ["1", "2"] }
    end
  end
end
