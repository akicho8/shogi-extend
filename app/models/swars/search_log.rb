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
# - Remarks ----------------------------------------------------------------------
# User.has_one :profile
# --------------------------------------------------------------------------------

module Swars
  class SearchLog < ApplicationRecord
    belongs_to :user, counter_cache: true, touch: :last_reception_at

    scope :old_only, -> expires_in { where(arel_table[:created_at].lt(expires_in.seconds.ago))   }
    scope :new_only, -> expires_in { where(arel_table[:created_at].gteq(expires_in.seconds.ago)) }

    class << self
      # 直近の期間 period に at_least 以上検索されたユーザーIDsを返す
      def momentum_user_ids(period: 3.days, at_least: 5)
        s = all
        s = s.new_only(period)                      # 直近期間
        s = s.having(["count_all >= ?", at_least])  # X回以上の検索
        s = s.order("count_all DESC")
        s.group(:user_id).count.keys
      end
    end
  end
end
