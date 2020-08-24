# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Setting (xclock_settings as Xclock::Setting)
#
# |--------------------+--------------------+-------------+-------------+--------------+-------|
# | name               | desc               | type        | opts        | refs         | index |
# |--------------------+--------------------+-------------+-------------+--------------+-------|
# | id                 | ID                 | integer(8)  | NOT NULL PK |              |       |
# | user_id            | User               | integer(8)  | NOT NULL    | => ::User#id | A     |
# | rule_id            | Rule               | integer(8)  | NOT NULL    |              | B     |
# | created_at         | 作成日時           | datetime    | NOT NULL    |              |       |
# | updated_at         | 更新日時           | datetime    | NOT NULL    |              |       |
# | session_lock_token | Session lock token | string(255) |             |              |       |
# |--------------------+--------------------+-------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

module Xclock
  class Setting < ApplicationRecord
    belongs_to :user, class_name: "::User"
    belongs_to :rule

    before_validation do
      self.rule ||= Rule.fetch(RuleInfo.default_key)
    end
  end
end
