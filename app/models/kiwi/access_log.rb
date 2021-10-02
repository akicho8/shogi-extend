# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Access log (kiwi_access_logs as Kiwi::AccessLog)
#
# |------------+----------+------------+-------------+--------------+-------|
# | name       | desc     | type       | opts        | refs         | index |
# |------------+----------+------------+-------------+--------------+-------|
# | id         | ID       | integer(8) | NOT NULL PK |              |       |
# | user_id    | User     | integer(8) |             | => ::User#id | A     |
# | book_id    | Book     | integer(8) | NOT NULL    |              | B     |
# | created_at | 作成日時 | datetime   | NOT NULL    |              |       |
# |------------+----------+------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

module Kiwi
  class AccessLog < ApplicationRecord
    belongs_to :user, class_name: "::User", optional: true
    belongs_to :book, counter_cache: true
  end
end
