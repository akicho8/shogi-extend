# frozen-string-literal: true

module Swars
  module User::Stat
    class RarityStat < Base
      delegate *[
        :ids_scope,
      ], to: :@stat

      def to_chart
        if total.positive?
          RarityInfo.reverse_each.collect do |e|
            { name: e.style_key, value: counts_hash[e.key] }
          end
        end
      end

      def majority?
        return instance_variable_get("@majority_p") if instance_variable_defined?("@majority_p")
        @majority ||= yield_self do
          if ratios_hash
            RarityInfo.find_all(&:majority).sum { |e| ratios_hash[e.key] } >= 0.5
          end
        end
      end

      def minority?
        if ratios_hash
          !majority?
        end
      end

      # { normal: 0.25, rare: 0.25, ... }
      def ratios_hash
        @ratios_hash ||= yield_self do
          if total.positive?
            RarityInfo.each_with_object({}) do |e, m|
              m[e.key] = counts_hash[e.key].fdiv(total)
            end
          end
        end
      end

      private

      def total
        @total ||= counts_hash.values.sum
      end

      # { normal: 5, rare: 5, ... }
      def counts_hash
        @counts_hash ||= yield_self do
          hv = RarityInfo.each_with_object({}) { |e, m| m[e.key] = 0 }
          tags.each do |e|
            if key = rarity_key_of(e)
              hv[key] += e.count
            end
          end
          hv
        end
      end

      def rarity_key_of(tag)
        if e = Bioshogi::Explain::TacticInfo.flat_lookup(tag.name)
          if e = e.distribution_ratio
            e.fetch(:rarity_key).to_sym
          end
        end
      end

      def tags
        @tags ||= [:attack_tags, :defense_tags].flat_map do |e|
          ids_scope.tag_counts_on(e)
        end
      end
    end
  end
end
