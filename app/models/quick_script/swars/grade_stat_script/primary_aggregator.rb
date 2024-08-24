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
      start_time = Time.current

      # タグを考慮しない頻度を作る
      # counts_hash = { "初段" => {"__tag_nothing__" => 9999} }

      counts_hash = {}
      s = main_scope
      s = s.joins(:grade).group("swars_grades.key")
      s.count.collect do |grade_key, count|
        counts_hash[grade_key] ||= {}
        counts_hash[grade_key]["__tag_nothing__"] = count
      end

      # タグを考慮した頻度を追加する
      # counts_hash = { "初段" => {"__tag_nothing__" => 9999, "棒銀" => 1234, ...} }

      s = s.joins(taggings: :tag).group("tags.name")
      s.count.collect do |(grade_key, tag_name), count|
        counts_hash[grade_key] ||= {}
        counts_hash[grade_key][tag_name] = count
      end

      {
        :memberships_count          => main_scope.count,
        :counts_hash                => counts_hash,
        :primary_aggregated_at      => Time.current,
        :primary_aggregation_second => Time.current - start_time,
      }
    end

    def main_scope
      s = @options[:scope] || ::Swars::Membership.all
      s = s.joins(:battle).where(::Swars::Battle.arel_table[:turn_max].gteq(::Swars::Config.seiritsu_gteq))
      s = s.where(grade: target_grades)
    end

    def target_grades
      keys = ::Swars::GradeInfo.find_all(&:visualize).pluck(:key)
      ::Swars::Grade.where(key: keys).unscope(:order)
    end
  end
end
