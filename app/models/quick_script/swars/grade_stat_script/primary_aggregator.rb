# frozen-string-literal: true

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
        :counts_hash                => aggregate,
        :total_user_count           => aggregate.values.sum { |e| e[:user][:__tag_nothing__] },
        :total_membership_count     => aggregate.values.sum { |e| e[:membership][:__tag_nothing__] },
        :primary_aggregated_at      => Time.current,
        :primary_aggregation_second => primary_aggregation_second,
      }
    end

    def aggregate
      @aggregate ||= {}.tap do |counts_hash|
        main_scope.in_batches(of: @options[:batch_size] || 1000).each.with_index do |relation, batch_index|
          puts "[#{Time.current.to_fs(:ymdhms)}][#{self.class.name}] Processing relation ##{batch_index}"
          relation = condition_add(relation) # 共通の激重条件を追加する

          # 人数
          sub_aggregate(counts_hash, :user, relation.joins(:grade).select(:user_id, "swars_grades.key").distinct)

          # 対局
          sub_aggregate(counts_hash, :membership, relation)
        end
      end
    end

    def sub_aggregate(counts_hash, population_key, scope)
      # タグを考慮しない頻度を作る
      # counts_hash = { "初段" => {user: {:__tag_nothing__ => 9999} }}

      scope = scope.joins(:grade).group("swars_grades.key")
      scope.count.collect do |grade_key, count|
        store(counts_hash, grade_key, population_key, :__tag_nothing__, count)
      end

      # タグを考慮した頻度を追加する
      # counts_hash = { "初段" => {user: {:__tag_nothing__ => 9999, "棒銀" => 1234, ...} }}

      scope = scope.joins(:taggings => :tag).group("tags.name")
      scope.count.collect do |(grade_key, tag_name), count|
        store(counts_hash, grade_key, population_key, tag_name, count)
      end
    end

    def store(counts_hash, grade_key, population_key, tag, count)
      counts_hash[grade_key] ||= {}
      counts_hash[grade_key][population_key] ||= {}
      counts_hash[grade_key][population_key][tag] ||= 0
      counts_hash[grade_key][population_key][tag] += count
    end

    # ここは軽くする
    def main_scope
      @options[:scope] || ::Swars::Membership.all
    end

    def target_grades
      keys = ::Swars::GradeInfo.find_all(&:visualize).pluck(:key)
      ::Swars::Grade.where(key: keys).unscope(:order)
    end

    # 激重条件はここでくっつける(重要)
    def condition_add(s)
      s = s.joins(:battle => :xmode)
      s = s.merge(::Swars::Battle.valid_match_only)
      s = s.where(grade: target_grades)
      s = s.where(::Swars::Xmode.arel_table[:key].eq(:"野良"))
    end
  end
end
