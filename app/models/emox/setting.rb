# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Setting (emox_settings as Emox::Setting)
#
# |--------------------+--------------------+-------------+-------------+--------------+-------|
# | name               | desc               | type        | opts        | refs         | index |
# |--------------------+--------------------+-------------+-------------+--------------+-------|
# | id                 | ID                 | integer(8)  | NOT NULL PK |              |       |
# | user_id            | User               | integer(8)  | NOT NULL    | => ::User#id | A     |
# | rule_id            | Rule               | integer(8)  | NOT NULL    |              | B     |
# | session_lock_token | Session lock token | string(255) |             |              |       |
# | created_at         | 作成日時           | datetime    | NOT NULL    |              |       |
# | updated_at         | 更新日時           | datetime    | NOT NULL    |              |       |
# |--------------------+--------------------+-------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

module Emox
  class Setting < ApplicationRecord
    belongs_to :user, class_name: "::User"
    belongs_to :rule

    before_validation do
      self.rule ||= Rule.fetch(RuleInfo.default_key)
    end
  end
end
