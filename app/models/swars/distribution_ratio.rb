# http://localhost:3000/api/swars/distribution_ratio
module Swars
  class DistributionRatio
    CURRENT_MAX = 10000
    BATCH_SIZE = Rails.env.development? ? 1 : 1000

    def initialize(options = {})
      @options = {
      }.merge(options)
    end

    def as_json(*)
      Rails.cache.fetch("distribution_ratio", expires_in: Rails.env.production? ? 1.days : 0) do
        to_a
      end
    end

    def to_a
      sdc = StandardDeviation.new(normalized_counts_hash.values)
      normalized_counts_hash.sort_by { |_, count| -count }.collect do |name, count|
        {
          :name         => name,                                    # 戦型名
          :count        => count,                                   # 個数
          :rarity       => sdc.appear_ratio(count),                 # 最大を0としたレア度
          :rarity_human => (100 - sdc.appear_ratio(count) * 100.0), # 最大を100としたレア度
        }
      end
    end

    private

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
              hv[e.name] ||= 0
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
  end
end
