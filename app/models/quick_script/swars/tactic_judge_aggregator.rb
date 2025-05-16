# frozen-string-literal: true

# 戦法ランキング用の一次集計
#
# rails r QuickScript::Swars::TacticJudgeAggregator.new.cache_write
#
# QuickScript::Swars::TacticJudgeAggregator.new.main_scope.count
# QuickScript::Swars::TacticJudgeAggregator.new.main_scope.joins(:taggings => :tag).count
# QuickScript::Swars::TacticJudgeAggregator.new.main_scope.joins(:taggings => :tag).joins(:judge).count
# .group("tags.name").group("judges.key").count
# Swars::Membership.joins(:taggings).count
# Swars::Membership.joins(:taggings => :tag).count
module QuickScript
  module Swars
    class TacticJudgeAggregator < Aggregator
      # 戦法一覧 (TacticListScript) 用の戦法名をキーにしたハッシュ
      # 期間は決め打ちでよい
      def tactics_hash
        @tactics_hash ||= yield_self do
          if aggregate.present?
            if records = aggregate.dig(:infinite, :records)
              records.inject({}) { |a, e| a.merge(e[:tag_name].to_sym => e) }
            end
          end
        end
      end

      # {:term1 => [ { :tag_name => "棒銀", ... } ] } の型に変換する
      def aggregate_now
        PeriodInfo.inject({}) do |a, period_info|
          counts_hash = {}
          win_lose_draw_total = 0
          memberships_count = 0

          batch_total = main_scope.count.ceildiv(batch_size)
          main_scope.in_batches(of: batch_size).each.with_index do |scope, batch_index|
            progress_log(batch_total, batch_index)

            scope = condition_add(scope, period_info)
            memberships_count += scope.count
            win_lose_draw_counts_hash = win_lose_draw_counts_hash_from(scope) # => { ["棒銀", "win"] => 2, ["棒銀", "lose"] => 3 }

            # { ["棒銀", "win"] => 2, ["棒銀", "lose"] => 3 } → { "棒銀" => { win_count: 2, lose_count: 3 } } の形に変換する
            win_lose_draw_counts_hash.each do |(tag_name, judge_key), count|
              counts_hash[tag_name] ||= JudgeInfo.inject({}) { |a, e| a.merge("#{e.key}_count".to_sym => 0) }
              counts_hash[tag_name][:"#{judge_key}_count"] += count
              win_lose_draw_total += count
            end
          end

          # さらに扱いやすい状態に調整する
          records = counts_hash_to_records(counts_hash, memberships_count)

          a.merge(period_info.key => {
              :records             => records,
              :win_lose_draw_total => win_lose_draw_total,
              :memberships_count   => memberships_count,
            })
        end
      end

      def win_lose_draw_counts_hash_from(s)
        s = s.joins(:taggings => :tag)
        s = s.joins(:judge)
        s = s.group("tags.name")
        s = s.group("judges.key")
        s.count
      end

      def counts_hash_to_records(counts_hash, memberships_count)
        counts_hash.collect do |tag_name, e|
          freq_count = e[:win_count] + e[:lose_count] + e[:draw_count]
          win_ratio  = e[:win_count].fdiv(freq_count)
          {
            :tag_name   => tag_name,
            :win_ratio  => win_ratio,
            :freq_ratio => freq_count.fdiv(memberships_count), # 分母は memberships 数でよい。freq_count を分母にしてはいけない
            :freq_count => freq_count,
            :win_count  => e[:win_count],
            :lose_count => e[:lose_count],
            :draw_count => e[:draw_count],
          }
        end
      end

      def condition_add(scope, period_info)
        scope = scope.joins(:battle => [:imode, :xmode])
        scope = scope.merge(::Swars::Battle.valid_match_only)
        scope = scope.where(::Swars::Imode.arel_table[:key].eq(:normal))
        scope = scope.where(::Swars::Xmode.arel_table[:key].eq(:"野良"))
        scope = scope.where(::Swars::Battle.arel_table[:analysis_version].eq(Bioshogi::ANALYSIS_VERSION))
        if v = period_info.period_second
          scope = scope.where(::Swars::Battle.arel_table[:battled_at].gteq(v.ago))
        end
        scope
      end
    end
  end
end
