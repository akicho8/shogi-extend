class QuickScript::Swars::TacticStatScript
  class PrimaryAggregator
    class << self
      def mock_setup
        ::Swars::Battle.create!(csa_seq: ::Swars::KifuGenerator.generate_n(14))
      end
    end

    def initialize(options = {})
      @options = options
    end

    def call
      start_time = Time.current

      s = main_scope.joins(:taggings => :tag)
      s = s.joins(:judge)
      s = s.group("tags.name")
      s = s.group("judges.key")
      coutns_hash = s.count

      # hv = { "棒銀" => { win_count: 2, lose_count: 3, draw_count: 1 } } の形に変換する

      hv = {}
      coutns_hash.each do |(tag_name, judge_key), count|
        hv[tag_name] ||= { win_count: 0, lose_count: 0, draw_count: 0 }
        hv[tag_name][:"#{judge_key}_count"] = count
      end

      # records = [ { tag_name => "棒銀", ... } ] の型に変換する

      records = hv.collect do |tag_name, e|
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
          :freq_ratio     => freq_count.fdiv(memberships_count),
        }
      end

      # JSON 型カラムにまとめていれる形に変換する

      {
        :memberships_count          => memberships_count,
        :records                    => records,
        :primary_aggregated_at      => Time.current,
        :primary_aggregation_second => Time.current - start_time,
      }
    end

    def main_scope
      s = @options[:scope] || ::Swars::Membership.all
      s = s.joins(:battle).where(::Swars::Battle.arel_table[:turn_max].gteq(::Swars::Config.seiritsu_gteq))
    end

    def memberships_count
      @memberships_count ||= main_scope.count
    end
  end
end
