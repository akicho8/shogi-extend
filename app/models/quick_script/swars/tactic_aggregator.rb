# frozen-string-literal: true

#
# 戦法の集計後の情報
#
# 一次集計: rails r QuickScript::Swars::TacticAggregator.new.cache_write
#

# QuickScript::Swars::TacticAggregator.new.main_scope.count
# QuickScript::Swars::TacticAggregator.new.main_scope.joins(:taggings => :tag).count
# QuickScript::Swars::TacticAggregator.new.main_scope.joins(:taggings => :tag).joins(:judge).count
# .group("tags.name").group("judges.key").count
# Swars::Membership.joins(:taggings).count
# Swars::Membership.joins(:taggings => :tag).count

module QuickScript
  module Swars
    class TacticAggregator
      include CacheMod

      class << self
        def mock_setup
          ::Swars::Battle.create!(strike_plan: "原始棒銀")
          # ::Swars::Battle.create!(csa_seq: ::Swars::KifuGenerator.generate_n(14))
        end
      end

      def initialize(options = {})
        @options = {}.merge(options)
      end

      def call
        aggregate
      end

      # TacticListScript から参照するときに便利な戦法名をキーにしたハッシュ
      # 期間2ヶ月決め打ちでよい
      def exta_hash
        @exta_hash ||= yield_self do
          if aggregate.present?
            if records = aggregate.dig(:day60, :records)
              records.inject({}) {|a, e| a.merge(e[:tag_name].to_sym => e) }
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
            puts "[#{Time.current.to_fs(:ymdhms)}][#{self.class.name}][#{period_info}] Processing relation ##{batch_index}/#{batch_total}"

            scope = condition_add(scope, period_info) # 激重条件はここ！(重要)
            memberships_count += scope.count
            win_lose_draw_counts_hash = win_lose_draw_counts_hash_from(scope) # => { ["棒銀", "win"] => 2, ["棒銀", "lose"] => 3 , ["棒銀", "draw"] => 1 }

            # { ["棒銀", "win"] => 2, ["棒銀", "lose"] => 3 , ["棒銀", "draw"] => 1 }
            # から
            # { "棒銀" => { win_count: 2, lose_count: 3, draw_count: 1 } } の形に変換する
            win_lose_draw_counts_hash.each do |(tag_name, judge_key), count|
              counts_hash[tag_name] ||= JudgeInfo.inject({}) { |a, e| a.merge("#{e.key}_count".to_sym => 0) }
              counts_hash[tag_name][:"#{judge_key}_count"] += count
              win_lose_draw_total += count
            end
          end

          # さらに扱いやすい状態に調整する
          records = counts_hash_to_records(counts_hash, win_lose_draw_total)

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

      def counts_hash_to_records(counts_hash, win_lose_draw_total)
        counts_hash.collect do |tag_name, e|
          freq_count = e[:win_count] + e[:lose_count] + e[:draw_count]
          win_ratio  = e[:win_count].fdiv(freq_count)
          {
            :tag_name   => tag_name,
            :win_count  => e[:win_count],
            :win_ratio  => win_ratio,
            :lose_count => e[:lose_count],
            :draw_count => e[:draw_count],
            :freq_count => freq_count,
            :freq_ratio => freq_count.fdiv(win_lose_draw_total),
          }
        end
      end

      def batch_size
        @options[:batch_size] || (Rails.env.local? ? 10000 : 1000)
      end

      # 【重要】
      # ここでは何もくっつけるな。
      # JOIN するのは in_batches のあとの 1000 件に対して行え。
      # ここで joins(:battle) などとすると300万件に対しての JOIN になるためそれで固まる。
      # 毎回 JOIN されるので遅いと勘違いしてしまいそうになるが、少ない件数に対して毎回 JOIN するので正しい。
      def main_scope
        @options[:scope] || ::Swars::Membership.all
      end

      # 激重条件はここ！(重要)
      def condition_add(s, period_info)
        s = s.joins(:battle => :xmode)
        s = s.merge(::Swars::Battle.valid_match_only)
        s = s.where(::Swars::Xmode.arel_table[:key].eq(:"野良"))
        s = s.where(::Swars::Battle.arel_table[:analysis_version].eq(Bioshogi::ANALYSIS_VERSION))
        if v = period_info.period_second
          s = s.where(::Swars::Battle.arel_table[:battled_at].gteq(v.ago))
        end
        s
      end
    end
  end
end
