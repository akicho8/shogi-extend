class QuickScript::Swars::GradeStatScript
  class PrimaryAggregator
    class << self
      def mock_setup
        ::Swars::Battle.create!(csa_seq: ::Swars::KifuGenerator.generate_n(14)) do |e|
          e.memberships.build(grade_key: "初段")
          e.memberships.build(grade_key: "初段")
        end
      end
    end

    def initialize(options = {})
      @options = options
    end

    def call
      primary_aggregation_second = Benchmark.realtime { aggregate }
      {
        :counts_hash                => aggregate[:counts_hash],
        :population_count           => aggregate[:population_count],
        :primary_aggregated_at      => Time.current,
        :primary_aggregation_second => primary_aggregation_second,
      }
    end

    def aggregate
      @aggregate ||= yield_self do
        counts_hash = {}
        population_count = 0

        main_scope.in_batches(of: @options[:batch_size] || 1000).each.with_index do |relation, batch_index|
          AppLog.info "[#{Time.current.to_fs(:ymdhms)}][#{self.class.name}] Processing relation ##{batch_index}"
          puts "[#{Time.current.to_fs(:ymdhms)}][#{self.class.name}] Processing relation ##{batch_index}"

          relation = condition_add(relation) # 共通の激重条件を追加する
          population_count += relation.count

          # タグを考慮しない頻度を作る
          # counts_hash = { "初段" => {"__tag_nothing__" => 9999} }

          s = relation
          s = s.joins(:grade).group("swars_grades.key")
          s.count.collect do |grade_key, count|
            counts_hash[grade_key] ||= {}
            counts_hash[grade_key]["__tag_nothing__"] ||= 0
            counts_hash[grade_key]["__tag_nothing__"] += count
          end

          # タグを考慮した頻度を追加する
          # counts_hash = { "初段" => {"__tag_nothing__" => 9999, "棒銀" => 1234, ...} }

          s = relation
          s = s.joins(:grade).group("swars_grades.key")
          s = s.joins(:taggings => :tag).group("tags.name")
          s.count.collect do |(grade_key, tag_name), count|
            counts_hash[grade_key] ||= {}
            counts_hash[grade_key][tag_name] ||= 0
            counts_hash[grade_key][tag_name] += count
          end
        end

        {
          :counts_hash      => counts_hash,
          :population_count => population_count,
        }
      end
    end

    # ここは軽くする
    def main_scope
      @options[:scope] || ::Swars::Membership.all
    end

    def target_grades
      keys = ::Swars::GradeInfo.find_all(&:visualize).pluck(:key)
      ::Swars::Grade.where(key: keys).unscope(:order)
    end

    def condition_add(s)
      s = s.joins(:battle).merge(::Swars::Battle.valid_match_only) # 激重条件はここでくっつける(重要)
      s = s.where(grade: target_grades)
    end
  end
end
