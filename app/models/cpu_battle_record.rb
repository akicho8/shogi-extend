# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Cpu battle record (cpu_battle_records as CpuBattleRecord)
#
# |------------+-----------+-------------+-------------+--------------+-------|
# | name       | desc      | type        | opts        | refs         | index |
# |------------+-----------+-------------+-------------+--------------+-------|
# | id         | ID        | integer(8)  | NOT NULL PK |              |       |
# | user_id    | User      | integer(8)  |             | => ::User#id | A     |
# | judge_key  | Judge key | string(255) | NOT NULL    |              | B     |
# | created_at | 作成日時  | datetime    | NOT NULL    |              |       |
# | updated_at | 更新日時  | datetime    | NOT NULL    |              |       |
# |------------+-----------+-------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

class CpuBattleRecord < ApplicationRecord
  class << self
    def setup(options = {})
      if Rails.env.production? || Rails.env.staging?
      else
        create!(user: User.sysop, judge_key: :win)
        create!(user: nil,                   judge_key: :lose)
      end
    end
  end

  belongs_to :user, class_name: "::User", required: false

  with_options presence: true do
    validates :judge_key
  end

  with_options allow_blank: true do
    validates :judge_key, inclusion: JudgeInfo.keys.collect(&:to_s)
  end
end
