# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Xy record (xy_records as XyRecord)
#
# |-------------------+----------------+-------------+-------------+-----------------------------+-------|
# | name              | desc           | type        | opts        | refs                        | index |
# |-------------------+----------------+-------------+-------------+-----------------------------+-------|
# | id                | ID             | integer(8)  | NOT NULL PK |                             |       |
# | colosseum_user_id | Colosseum user | integer(8)  |             | :user => Colosseum::User#id | A     |
# | entry_name        | Entry name     | string(255) |             |                             |       |
# | summary           | Summary        | string(255) |             |                             |       |
# | xy_rule_key       | Xy rule key    | string(255) | NOT NULL    |                             | B     |
# | x_count           | X count        | integer(4)  | NOT NULL    |                             |       |
# | spent_msec        | Spent msec     | float(24)   | NOT NULL    |                             |       |
# | created_at        | 作成日時       | datetime    | NOT NULL    |                             |       |
# | updated_at        | 更新日時       | datetime    | NOT NULL    |                             |       |
# |-------------------+----------------+-------------+-------------+-----------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_many :free_battles, foreign_key: :colosseum_user_id
#--------------------------------------------------------------------------------

class XyRecord < ApplicationRecord
  MSEC_ACCURACY = 1000

  belongs_to :user, class_name: "Colosseum::User", foreign_key: "colosseum_user_id", required: false

  before_validation do
    if summary
      self.summary = summary.to_s.squish
    end
    if entry_name
      self.entry_name = entry_name.to_s.squish
    end
  end

  with_options presence: true do
    validates :xy_rule_key
    validates :x_count
    validates :spent_msec
  end

  with_options allow_blank: true do
    validates :xy_rule_key, inclusion: XyRuleInfo.keys.collect(&:to_s)
  end

  after_create do
    ranking_store
  end

  def rank
    XyRuleInfo[xy_rule_key].rank_by_score(score)
  end

  def ranking_page
    XyRuleInfo[xy_rule_key].ranking_page(id)
  end

  def ranking_store
    XyRuleInfo[xy_rule_key].ranking_store(self)
  end

  def score
    spent_msec * MSEC_ACCURACY * -1
  end
end
