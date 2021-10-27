# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Time record (ts_master_time_records as TsMaster::TimeRecord)
#
# |------------+------------+-------------+-------------+--------------+-------|
# | name       | desc       | type        | opts        | refs         | index |
# |------------+------------+-------------+-------------+--------------+-------|
# | id         | ID         | integer(8)  | NOT NULL PK |              |       |
# | user_id    | User       | integer(8)  |             | => ::User#id | A     |
# | entry_name | Entry name | string(255) | NOT NULL    |              | B     |
# | summary    | Summary    | string(255) |             |              |       |
# | rule_id    | Rule       | integer(8)  | NOT NULL    |              | C     |
# | x_count    | X count    | integer(4)  | NOT NULL    |              |       |
# | spent_sec  | Spent sec  | float(24)   | NOT NULL    |              |       |
# | created_at | 作成日時   | datetime    | NOT NULL    |              |       |
# | updated_at | 更新日時   | datetime    | NOT NULL    |              |       |
# |------------+------------+-------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

module TsMaster
  class TimeRecord < ApplicationRecord
    ACCURACY = 3

    class << self
      def setup(options = {})
        if Rails.env.development?
          create!(rule_key: "rule_mate7_type1", entry_name: "a", spent_sec: 0.2, x_count: 0)
          create!(rule_key: "rule_mate7_type1", entry_name: "a", spent_sec: 0.3, x_count: 0)
          create!(rule_key: "rule_mate7_type1", entry_name: "b", spent_sec: 0.2, x_count: 0)
          create!(rule_key: "rule_mate7_type1", entry_name: "b", spent_sec: 0.3, x_count: 0)
        end

        if Rails.env.test?
          create!(rule_key: "rule_mate7_type1", entry_name: "a", spent_sec: 0.2, x_count: 0)
        end

        # RuleInfo.rebuild
      end
    end

    scope :entry_name_blank_scope, -> { where(entry_name: nil).where(arel_table[:created_at].lt(1.hour.ago) ) }

    belongs_to :user, class_name: "::User", required: false
    belongs_to :rule

    before_validation do
      if summary
        self.summary = summary.to_s.squish
      end
      if entry_name
        self.entry_name = entry_name.to_s.squish.presence
      end

      # ランキングで同じ順位なのに表記が異なる場合があるのを避けるため
      if spent_sec
        self.spent_sec = spent_sec.floor(ACCURACY)
      end
    end

    with_options presence: true do
      validates :rule_id
      validates :x_count
      validates :spent_sec
      validates :entry_name
    end

    after_create do
      ranking_add
    end

    after_destroy do
      ranking_remove
    end

    def rule_key=(v)
      self.rule_id = Rule.fetch(v).id
    end

    def rule_key
      rule.key
    end

    def rank(params)
      rule.pure_info.rank_by_score(params, score)
    end

    def ranking_page(params)
      rule.pure_info.ranking_page(params, id)
    end

    def score
      spent_sec * 10**ACCURACY * -1
    end

    def spent_sec_time_format
      "%d:%02d.%d" % [spent_sec / 60, spent_sec % 60, (spent_sec % 1) * 10**ACCURACY]
    end

    def slack_notify
      rank = rank(scope_key: :scope_all)
      SlackAgent.notify(subject: "詰将棋", body: "[#{rank}位][#{entry_name}] #{summary}")
    end

    def rank_info
      ScopeInfo.inject({}) do |a, e|
        args = {scope_key: e.key, entry_name_uniq_p: false}
        a.merge(e.key => { rank: rank(args), page: ranking_page(args) })
      end
    end

    # 自己ベストを更新したときの情報
    #
    # assert { TimeRecord.create!(rule_key: "rule_mate3_type1", entry_name: "x", spent_sec: 100.333, x_count: 0).best_update_info == nil                       }
    # assert { TimeRecord.create!(rule_key: "rule_mate3_type1", entry_name: "x", spent_sec: 100.334, x_count: 0).best_update_info == nil                       }
    # assert { TimeRecord.create!(rule_key: "rule_mate3_type1", entry_name: "x", spent_sec: 100.332, x_count: 0).best_update_info == {updated_spent_sec: 0.001 }  }
    #
    def best_update_info
      s = self.class.where(rule: rule).where(entry_name: entry_name)

      # 小数の比較だと自分が 1.1 として v > 1.1 としても自分が含まれてしまうため id で除外している
      next_record = s.where.not(id: id).where(self.class.arel_table[:spent_sec].gt(spent_sec)).order(:spent_sec).first # 今回の記録の次の記録をもつレコード
      if next_record
        top = s.order(:spent_sec).first # 自己ベスト
        if top == self
          { updated_spent_sec: (next_record.spent_sec - spent_sec).floor(ACCURACY) }
        end
      end
    end

    # def json_attributes(params)
    #   attributes.merge(rank: rank(params), rule_key: rule_key)
    # end

    private

    def ranking_add
      rule.pure_info.ranking_add(self)
    end

    def ranking_remove
      rule.pure_info.ranking_remove(self)
    end
  end
end
