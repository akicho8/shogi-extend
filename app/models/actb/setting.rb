# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Setting (actb_settings as Actb::Setting)
#
# |------------+----------+-------------+-------------+-----------------------+-------|
# | name       | desc     | type        | opts        | refs                  | index |
# |------------+----------+-------------+-------------+-----------------------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |                       |       |
# | user_id    | User     | integer(8)  | NOT NULL    | => Colosseum::User#id | A     |
# | rule_key   | Rule key | string(255) | NOT NULL    |                       | B     |
# | created_at | 作成日時 | datetime    | NOT NULL    |                       |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |                       |       |
# |------------+----------+-------------+-------------+-----------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_one :actb_xrecord
#--------------------------------------------------------------------------------

module Actb
  class Setting < ApplicationRecord
    belongs_to :user, class_name: "Colosseum::User"

    before_validation do
      self.rule_key ||= RuleInfo.fetch(:marathon_rule).key
    end

    with_options presence: true do
      validates :rule_key
    end

    with_options allow_blank: true do
      validates :rule_key, inclusion: RuleInfo.keys.collect(&:to_s)
    end

    def rule_info
      RuleInfo.fetch(rule_key)
    end
  end
end
