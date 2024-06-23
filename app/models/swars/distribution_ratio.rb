# http://localhost:3000/api/swars/distribution_ratio
# https://www.shogi-extend.com/api/swars/distribution_ratio
module Swars
  class DistributionRatio
    CURRENT_MAX = 50000
    BATCH_SIZE = Rails.env.development? ? 1 : 2000

    def initialize(options = {})
      @options = {
      }.merge(options)
    end

    def as_json(*)
      Rails.cache.fetch("distribution_ratio", expires_in: Rails.env.local? ? 0.days : 1.days) do
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
      @ivalues ||= total_counts_hash.values
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

    # 最低最大出現率
    def minmax
      @minmax ||= fvalues.minmax
    end

    # 出現率平均
    def avg
      sd2.avg
    end

    def meta
      {
        :minmax      => minmax, # 最低最大出現率
        :avg         => avg,
        :items_total => total_counts_hash.count,
        :ignore_keys => ignore_keys,
        :histogram   => histogram,
      }
    end

    def items
      @items ||= yield_self do
        total_counts_hash.sort_by { |_, count| -count }.each.with_index.collect do |(name, count), i|
          v = sd1.appear_ratio(count)
          {
            :index          => i,
            :name           => name,
            :count          => count,                 # 個数
            :emission_ratio => v,                     # 排出率
            :diff_from_avg  => v - avg,               # 平均出現率との差(つまり0以上であれば王道戦法)
            :rarity_key     => rarity_info_of(v).key, # レア度区分
          }
        end
      end
    end

    def rarity_info_of(value)
      RarityInfo.find { |e| value <= e.ratio } or raise "must not happen"
    end

    def total_counts_hash
      @total_counts_hash ||= all_keys.inject({}) { |a, e| a.merge(e => counts_hash[e]) }.except(*ignore_keys)
    end

    # {"棒銀" => 1}
    def counts_hash
      @counts_hash ||= yield_self do
        hv = Hash.new(0)
        i = 0
        Membership.in_batches(of: BATCH_SIZE, order: :desc) do |s|
          if i >= loop_max
            break
          end
          tactic_keys.each do |tactic_key|
            tags = s.tag_counts_on("#{tactic_key}_tags")
            tags.each do |e|
              hv[e.name] += e.count
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
      ["居玉", "力戦"]
    end

    # レア度の分布情報を返す
    def histogram
      @histogram ||= yield_self do
        group = items.group_by { |e| e[:rarity_key] }
        hash = group.transform_values { |e| e.sum { |e| e[:count] } }
        total = hash.values.sum
        if total.positive?
          RarityInfo.collect do |e|
            count = hash[e.key] || 0
            {
              :key   => e.key,
              :count => count,
              :rate  => count.fdiv(total),
            }
          end
        end
      end
    end
  end
end
