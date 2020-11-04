# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Draft box (emox_folders as Emox::DraftBox)
#
# |------------+------------+-------------+-------------+--------------------+-------|
# | name       | desc       | type        | opts        | refs               | index |
# |------------+------------+-------------+-------------+--------------------+-------|
# | id         | ID         | integer(8)  | NOT NULL PK |                    |       |
# | user_id    | User       | integer(8)  | NOT NULL    | => User#id         | A! B  |
# | type       | 所属モデル | string(255) | NOT NULL    | SpecificModel(STI) | A!    |
# | created_at | 作成日時   | datetime    | NOT NULL    |                    |       |
# | updated_at | 更新日時   | datetime    | NOT NULL    |                    |       |
# |------------+------------+-------------+-------------+--------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

module Emox
  class DraftBox < Folder
  end
end
