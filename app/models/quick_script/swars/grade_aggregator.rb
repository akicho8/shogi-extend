# frozen-string-literal: true

# 段級位毎の個数を調べる
#
# 一次集計
# rails r QuickScript::Swars::GradeAggregator.new.cache_write
#
module QuickScript
  module Swars
    class GradeAggregator < Aggregator
      class << self
        def mock_setup
          alice = ::Swars::User.create!
          bob = ::Swars::User.create!
          carol = ::Swars::User.create!
          battles = []
          battles << ::Swars::Battle.create!(strike_plan: "GAVA角") do |e|
            e.memberships.build(user: alice, grade_key: "九段")
            e.memberships.build(user: bob, grade_key: "初段")
          end
          battles << ::Swars::Battle.create!(strike_plan: "GAVA角") do |e|
            e.memberships.build(user: alice, grade_key: "九段")
            e.memberships.build(user: carol, grade_key: "初段")
          end
          battles
        end
      end

      def aggregate_now
        FrequencyInfo.inject({}) do |a, frequency_info|
          plain_counts = Hash.new(0)
          tag_counts = Hash.new { |h, k| h[k] = Hash.new(0) }

          progress_start(main_scope.count.ceildiv(batch_size))
          main_scope.in_batches(of: batch_size).each.with_index do |scope, batch_index|
            progress_next(frequency_info)

            scope = condition_add(scope)
            scope = frequency_info.scope_chain[scope] # scope = scope.joins(:grade).select(:user_id, "swars_grades.key").distinct

            scope = scope.joins(:grade).group("swars_grades.key")
            scope.count.each { |grade_key, count| plain_counts[grade_key] += count }

            scope = scope.joins(taggings: :tag).group("tags.name")
            scope.count.collect { |(grade_key, tag_name), count| tag_counts[tag_name][grade_key] += count }
          end

          a.merge(frequency_info.key => { plain_counts: plain_counts, tag_counts: tag_counts })
        end
      end

      def target_grades
        keys = ::Swars::GradeInfo.find_all(&:visualize).pluck(:key)
        ::Swars::Grade.where(key: keys).unscope(:order)
      end

      def condition_add(s)
        s = s.joins(:battle => [:imode, :xmode])
        s = s.merge(::Swars::Battle.valid_match_only)
        s = s.where(grade: target_grades)
        s = s.where(::Swars::Imode.arel_table[:key].eq(:normal))
        s = s.where(::Swars::Xmode.arel_table[:key].eq(:"野良"))
      end
    end
  end
end
