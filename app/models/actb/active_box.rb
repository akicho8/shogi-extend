# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Active box (actb_folders as Actb::ActiveBox)
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

module Actb
  class ActiveBox < Folder
  end
end
