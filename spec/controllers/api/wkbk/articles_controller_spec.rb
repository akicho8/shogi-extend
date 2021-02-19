# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Article (wkbk_articles as Wkbk::Article)
#
# |---------------------+---------------------+--------------+---------------------+--------------+-------|
# | name                | desc                | type         | opts                | refs         | index |
# |---------------------+---------------------+--------------+---------------------+--------------+-------|
# | id                  | ID                  | integer(8)   | NOT NULL PK         |              |       |
# | key                 | ユニークなハッシュ  | string(255)  | NOT NULL            |              | A!    |
# | user_id             | User                | integer(8)   | NOT NULL            | => ::User#id | B     |
# | folder_id           | Folder              | integer(8)   | NOT NULL            |              | C     |
# | lineage_id          | Lineage             | integer(8)   | NOT NULL            |              | D     |
# | init_sfen           | Init sfen           | string(255)  | NOT NULL            |              | E     |
# | viewpoint           | Viewpoint           | string(255)  | NOT NULL            |              |       |
# | title               | タイトル            | string(100)  | NOT NULL            |              |       |
# | description         | 解説                | string(5000) | NOT NULL            |              |       |
# | direction_message   | Direction message   | string(100)  | NOT NULL            |              |       |
# | turn_max            | 手数                | integer(4)   | NOT NULL            |              | F     |
# | mate_skip           | Mate skip           | boolean      | NOT NULL            |              |       |
# | moves_answers_count | Moves answers count | integer(4)   | DEFAULT(0) NOT NULL |              |       |
# | difficulty          | Difficulty          | integer(4)   | NOT NULL            |              | G     |
# | answer_logs_count   | Answer logs count   | integer(4)   | DEFAULT(0) NOT NULL |              |       |
# | created_at          | 作成日時            | datetime     | NOT NULL            |              |       |
# | updated_at          | 更新日時            | datetime     | NOT NULL            |              |       |
# |---------------------+---------------------+--------------+---------------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

require 'rails_helper'

RSpec.describe Api::Wkbk::ArticlesController, type: :controller do
  before(:context) do
    Actb.setup
    Emox.setup
    Wkbk.setup
    Wkbk::Book.mock_setup
    # tp Wkbk.info
    # tp Wkbk::Book
  end

  [
    { args: [ :index, params: {                    }],               code: 200, },
    { args: [ :edit,  params: {                    }],               code: 403, },
    { args: [ :edit,  params: {                    }], user: :sysop, code: 200, },
    { args: [ :show,  params: { article_key: 1,    }],               code: 200, },
    { args: [ :show,  params: { article_key: 2,    }],               code: 403, },
    { args: [ :show,  params: { article_key: 9999, }],               code: 404, },
    { args: [ :show,  params: { article_key: 2,    }], user: :sysop, code: 200, },
    { args: [ :show,  params: { article_key: 4,    }], user: :sysop, code: 403, },
    { args: [ :edit,  params: { article_key: 1,    }],               code: 403, },
    { args: [ :edit,  params: { article_key: 1,    }], user: :sysop, code: 200, },
    { args: [ :edit,  params: { article_key: 2,    }],               code: 403, },
    { args: [ :edit,  params: { article_key: 2,    }], user: :sysop, code: 200, },
    { args: [ :edit,  params: { article_key: 3,    }],               code: 403, },
    { args: [ :edit,  params: { article_key: 3,    }], user: :sysop, code: 404, },
    { args: [ :edit,  params: { article_key: 4,    }],               code: 403, },
    { args: [ :edit,  params: { article_key: 4,    }], user: :sysop, code: 404, },
    { args: [ :edit,  params: { article_key: 9999, }], user: :sysop, code: 404, },
  ].each do |e|
    it "アクセス制限" do
      if e[:user]
        user_login(User.sysop)
      end
      get *e[:args]
      expect(response).to have_http_status(e[:code])
    end
  end
end
