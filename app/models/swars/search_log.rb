# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Search log (swars_search_logs as Swars::SearchLog)
#
# |------------+----------+------------+-------------+------------+-------|
# | name       | desc     | type       | opts        | refs       | index |
# |------------+----------+------------+-------------+------------+-------|
# | id         | ID       | integer(8) | NOT NULL PK |            |       |
# | user_id    | User     | integer(8) | NOT NULL    | => User#id | A     |
# | created_at | 作成日時 | datetime   | NOT NULL    |            |       |
# | updated_at | 更新日時 | datetime   | NOT NULL    |            |       |
# |------------+----------+------------+-------------+------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

module Swars
  class SearchLog < ApplicationRecord
    belongs_to :user, counter_cache: true, touch: :last_reception_at
  end
end
