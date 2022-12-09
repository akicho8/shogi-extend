# http://localhost:3000/api/swars/distribution_ratio
# https://www.shogi-extend.com/api/swars/distribution_ratio
module Swars
  class DistributionRatio
    CURRENT_MAX = 30000
    BATCH_SIZE = Rails.env.development? ? 1 : 2000

    def initialize(options = {})
      @options = {
      }.merge(options)
    end

    def as_json(*)
      Rails.cache.fetch("distribution_ratio", expires_in: Rails.env.production? ? 1.days : 0) do
        to_h
      end
    end

    def to_h
      {
        :meta        => meta,
        :rarity_info => RarityInfo,
        :items       => items,
      }
    end

    private

    # 出現個数
    def ivalues
      @ivalues ||= normalized_counts_hash.values
    end

    # 出現率を出すためのもの
    def sd1
      @sd1 ||= StandardDeviation.new(ivalues)
    end

    # 出現率のリスト
    def fvalues
      @fvalues ||= ivalues.collect { |e| sd1.appear_ratio(e) }
    end

    # 出現率で再度
    def sd2
      @sd2 ||= StandardDeviation.new(fvalues)
    end

    # 最低出現率
    def min
      @min ||= fvalues.min
    end

    # 最大出現率
    def max
      @max ||= fvalues.max
    end

    # 出現率平均
    def avg
      sd2.avg
    end

    def meta
      {
        :min => min, # 最低出現率
        :avg => avg, # 平均出現率
        :max => max, # 最大出現率
        :items_total => normalized_counts_hash.count,
      }
    end

    def items
      normalized_counts_hash.sort_by { |_, count| -count }.collect.with_index do |(name, count), i|
        v = sd1.appear_ratio(count)
        {
          :index          => i,
          :name           => name,                  # 戦型名
          :count          => count,                 # 個数
          :emission_ratio => v,                     # 排出率
          :diff_from_avg  => v - avg,               # 平均出現率との差(つまり0以上であれば王道戦法)
          :rarity_key     => rarity_info_of(v).key, # レア度区分
        }
      end
    end

    def rarity_info_of(value)
      RarityInfo.find { |e| value <= e.ratio } or raise "must not happen"
    end

    def normalized_counts_hash
      @normalized_counts_hash ||= all_keys.inject({}) { |a, e| a.merge(e => counts_hash[e] || 0) }
    end

    # {"棒銀" => 1}
    def counts_hash
      @counts_hash ||= yield_self do
        hv = {}
        i = 0
        Membership.in_batches(of: BATCH_SIZE, order: :desc) do |s|
          if i >= loop_max
            break
          end
          tactic_keys.each do |tactic_key|
            tags = s.tag_counts_on("#{tactic_key}_tags")
            tags.each do |e|
              if ignore_keys.exclude?(e.name)
                hv[e.name] ||= 0
                hv[e.name] += e.count
              end
            end
          end
          i += 1
        end
        hv
      end
    end

    def loop_max
      @loop_max ||= CURRENT_MAX.fdiv(BATCH_SIZE).ceil
    end

    # ["棒銀", "アヒル囲い"]
    def all_keys
      @all_keys ||= tactic_keys.flat_map { |e| Bioshogi::Explain::TacticInfo.fetch(e).model.keys.collect(&:to_s) }
    end

    def tactic_keys
      [:attack, :defense]
    end

    def ignore_keys
      ["居玉", "力戦", "相振り飛車"]
    end
  end
end
