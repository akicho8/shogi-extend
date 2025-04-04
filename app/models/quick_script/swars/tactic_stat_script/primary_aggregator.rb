# QuickScript::Swars::TacticStatScript::PrimaryAggregator.new.main_scope.count
# QuickScript::Swars::TacticStatScript::PrimaryAggregator.new.main_scope.joins(:taggings => :tag).count
# QuickScript::Swars::TacticStatScript::PrimaryAggregator.new.main_scope.joins(:taggings => :tag).joins(:judge).count
# .group("tags.name").group("judges.key").count
# Swars::Membership.joins(:taggings).count
# Swars::Membership.joins(:taggings => :tag).count

class QuickScript::Swars::TacticStatScript
  class PrimaryAggregator
    class << self
      def mock_setup
        ::Swars::Battle.create!(csa_seq: ::Swars::KifuGenerator.generate_n(14))
      end
    end

    def initialize(options = {})
      @options = {}.merge(options)
    end

    def call
      primary_aggregation_second = TimeTrial.realtime { aggregate }
      {
        :period_based_agg           => period_based_agg,
        :primary_aggregated_at      => Time.current,
        :primary_aggregation_second => primary_aggregation_second,
      }
    end

    # aggregate = {:term1 => [ { :tag_name => "棒銀", ... } ] } の型に変換する
    def period_based_agg
      hv = {}
      PeriodInfo.each do |period_info|
        one = aggregate[period_info.key]
        records = one[:counts_hash].collect do |tag_name, e|
          freq_count     = e[:win_count] + e[:lose_count] + e[:draw_count]
          win_lose_count = e[:win_count] + e[:lose_count]
          win_ratio      = e[:win_count].fdiv(win_lose_count)
          {
            :tag_name       => tag_name,
            :win_count      => e[:win_count],
            :win_ratio      => win_ratio,
            :lose_count     => e[:lose_count],
            :draw_count     => e[:draw_count],
            :freq_count     => freq_count,
            :win_lose_count => win_lose_count, # 未使用
            :freq_ratio     => freq_count.fdiv(one[:population_count]),
          }
        end
        hv[period_info.key] = {
          :records          => records,
          :population_count => one[:population_count],
        }
      end
      hv
    end

    def aggregate
      @aggregate ||= yield_self do
        PeriodInfo.inject({}) do |a, period_info|
          counts_hash = {}
          population_count = 0

          main_scope.in_batches(of: @options[:batch_size] || 1000).each.with_index do |relation, batch_index|
            puts "[#{Time.current.to_fs(:ymdhms)}][#{self.class.name}] Processing relation ##{batch_index}"

            relation = condition_add(relation, period_info) # 激重条件はここ！(重要)
            population_count += relation.count

            s = relation
            s = s.joins(:taggings => :tag)
            s = s.joins(:judge)
            s = s.group("tags.name")
            s = s.group("judges.key")
            sub_counts_hash = s.count

            # counts_hash = { "棒銀" => { win_count: 2, lose_count: 3, draw_count: 1 } } の形に変換する

            sub_counts_hash.each do |(tag_name, judge_key), count|
              counts_hash[tag_name] ||= { win_count: 0, lose_count: 0, draw_count: 0 }
              counts_hash[tag_name][:"#{judge_key}_count"] += count
            end
          end

          a.merge(period_info.key => {
              :counts_hash      => counts_hash,
              :population_count => population_count,
            })
        end
      end
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
