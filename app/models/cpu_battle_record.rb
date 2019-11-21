# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Cpu battle record (cpu_battle_records as CpuBattleRecord)
#
# |-------------------+----------------+-------------+-------------+-----------------------------+-------|
# | name              | desc           | type        | opts        | refs                        | index |
# |-------------------+----------------+-------------+-------------+-----------------------------+-------|
# | id                | ID             | integer(8)  | NOT NULL PK |                             |       |
# | colosseum_user_id | Colosseum user | integer(8)  |             | :user => Colosseum::User#id | A     |
# | judge_key         | Judge key      | string(255) | NOT NULL    |                             | B     |
# | created_at        | 作成日時       | datetime    | NOT NULL    |                             |       |
# | updated_at        | 更新日時       | datetime    | NOT NULL    |                             |       |
# |-------------------+----------------+-------------+-------------+-----------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_many :free_battles, foreign_key: :colosseum_user_id
#--------------------------------------------------------------------------------

class CpuBattleRecord < ApplicationRecord
  class << self
    def setup(options = {})
      unless Rails.env.production?
        create!(user: Colosseum::User.sysop, judge_key: :win)
        create!(user: nil,                   judge_key: :lose)
      end
    end
  end

  belongs_to :user, class_name: "Colosseum::User", foreign_key: "colosseum_user_id", required: false

  with_options presence: true do
    validates :judge_key
  end

  with_options allow_blank: true do
    validates :judge_key, inclusion: JudgeInfo.keys.collect(&:to_s)
  end
end
