# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Folder (kiwi_folders as Kiwi::Folder)
#
# |---------------+---------------+-------------+---------------------+------+-------|
# | name          | desc          | type        | opts                | refs | index |
# |---------------+---------------+-------------+---------------------+------+-------|
# | id            | ID            | integer(8)  | NOT NULL PK         |      |       |
# | key           | キー          | string(255) | NOT NULL            |      | A!    |
# | position      | 順序          | integer(4)  | NOT NULL            |      | B     |
# | bananas_count | Bananas count | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | created_at    | 作成日時      | datetime    | NOT NULL            |      |       |
# | updated_at    | 更新日時      | datetime    | NOT NULL            |      |       |
# |---------------+---------------+-------------+---------------------+------+-------|

module Kiwi
  class Folder < ApplicationRecord
    include MemoryRecordBind::Basic

    with_options dependent: :restrict_with_exception do
      has_many :bananas
    end
  end
end
