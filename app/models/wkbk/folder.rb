# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Folder (wkbk_folders as Wkbk::Folder)
#
# |----------------+--------------------+-------------+---------------------+------+-------|
# | name           | desc               | type        | opts                | refs | index |
# |----------------+--------------------+-------------+---------------------+------+-------|
# | id             | ID                 | integer(8)  | NOT NULL PK         |      |       |
# | key            | ユニークなハッシュ | string(255) | NOT NULL            |      | A!    |
# | position       | 順序               | integer(4)  | NOT NULL            |      | B     |
# | books_count    | Books count        | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | articles_count | Articles count     | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | created_at     | 作成日時           | datetime    | NOT NULL            |      |       |
# | updated_at     | 更新日時           | datetime    | NOT NULL            |      |       |
# |----------------+--------------------+-------------+---------------------+------+-------|

module Wkbk
  class Folder < ApplicationRecord
    include MemoryRecordBind

    with_options dependent: :restrict_with_exception do
      has_many :books
      has_many :articles
    end
  end
end
