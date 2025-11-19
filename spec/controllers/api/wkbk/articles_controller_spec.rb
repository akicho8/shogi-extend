# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Article (wkbk_articles as Wkbk::Article)
#
# |---------------------+---------------------+-------------+---------------------+------+-------|
# | name                | desc                | type        | opts                | refs | index |
# |---------------------+---------------------+-------------+---------------------+------+-------|
# | id                  | ID                  | integer(8)  | NOT NULL PK         |      |       |
# | key                 | キー                | string(255) | NOT NULL            |      | A!    |
# | user_id             | User                | integer(8)  | NOT NULL            |      | B     |
# | folder_id           | Folder              | integer(8)  | NOT NULL            |      | C     |
# | lineage_id          | Lineage             | integer(8)  | NOT NULL            |      | D     |
# | init_sfen           | Init sfen           | string(255) | NOT NULL            |      | E     |
# | viewpoint           | Viewpoint           | string(255) | NOT NULL            |      |       |
# | title               | タイトル            | string(100) | NOT NULL            |      |       |
# | description         | 説明                | text(65535) | NOT NULL            |      |       |
# | direction_message   | Direction message   | string(100) | NOT NULL            |      |       |
# | turn_max            | 手数                | integer(4)  | NOT NULL            |      | F     |
# | mate_skip           | Mate skip           | boolean     | NOT NULL            |      |       |
# | moves_answers_count | Moves answers count | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | difficulty          | Difficulty          | integer(4)  | NOT NULL            |      | G     |
# | answer_logs_count   | Answer logs count   | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | created_at          | 作成日時            | datetime    | NOT NULL            |      |       |
# | updated_at          | 更新日時            | datetime    | NOT NULL            |      |       |
# |---------------------+---------------------+-------------+---------------------+------+-------|
#
# - Remarks ----------------------------------------------------------------------
# [Warning: Need to add relation] Wkbk::Article モデルに belongs_to :lineage を追加しよう
# [Warning: Need to add relation] Wkbk::Article モデルに belongs_to :user を追加しよう
# --------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe Api::Wkbk::ArticlesController, type: :controller do
  include WkbkSupportMethods
  [
    { action: :index, params: {},                                 status: 200, },
    { action: :edit,  params: {},                                 status: 403, },
    { action: :edit,  params: {},                   user: :admin, status: 200, },
    { action: :show,  params: { article_key: 1,  },               status: 200, },
    { action: :show,  params: { article_key: 2,  },               status: 403, },
    { action: :show,  params: { article_key: :x, },               status: 404, },
    { action: :show,  params: { article_key: 2,  }, user: :admin, status: 200, },
    { action: :show,  params: { article_key: 4,  }, user: :admin, status: 403, },
    { action: :edit,  params: { article_key: 1,  },               status: 403, },
    { action: :edit,  params: { article_key: 1,  }, user: :admin, status: 200, },
    { action: :edit,  params: { article_key: 2,  },               status: 403, },
    { action: :edit,  params: { article_key: 2,  }, user: :admin, status: 200, },
    { action: :edit,  params: { article_key: 3,  },               status: 403, },
    { action: :edit,  params: { article_key: 3,  }, user: :admin, status: 404, },
    { action: :edit,  params: { article_key: 4,  },               status: 403, },
    { action: :edit,  params: { article_key: 4,  }, user: :admin, status: 404, },
    { action: :edit,  params: { article_key: :x, }, user: :admin, status: 404, },
  ].each do |e|
    it "アクセス制限" do
      if e[:user]
        user_login(User.admin)
      end
      get e[:action], params: e[:params]
      assert { response.status == e[:status] }
    end
  end

  describe "new" do
    it "works" do
      user_login(User.admin)
      get :edit, params: { tag_list: "a,b c", book_keys: "1,2" }
      info = JSON.parse(response.body)
      assert { info["article"]["tag_list"] == ["a", "b", "c"] }
      assert { info["books"].collect { |e| e["key"] } == ["1", "2"] }
    end
  end
end
