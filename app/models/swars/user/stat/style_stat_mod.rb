# frozen-string-literal: true

module Swars
  module User::Stat
    concern :StyleStatMod do
      included do
        delegate *[
          :ids_scope,
          :tag_stat,
        ], to: :stat
      end

      def to_chart
        @to_chart ||= yield_self do
          if denominator.positive?
            StyleInfo.collect do |e|
              { name: e.name, value: counts_hash[e.key] || 0 }
            end
          end
        end
      end

      # 王道の割合い
      # これが 0.5 以上なら王道
      def majority_ratio
        @majority_ratio ||= yield_self do
          if denominator.positive?
            StyleInfo.find_all { |e| e.segment == :majority }.sum { |e| ratios_hash[e.key] }
          end
        end
      end

      # 変態の割合い
      # これが 0.5 以上なら変態
      def minority_ratio
        @minority_ratio ||= yield_self do
          if denominator.positive?
            StyleInfo.find_all { |e| e.segment == :minority }.sum { |e| ratios_hash[e.key] }
          end
        end
      end

      # Swars::User["bsplive"].stat.style_stat_mod.ratios_hash     # => {:rarity_key_SSR=>0.14035087719298245, :rarity_key_SR=>0.2807017543859649, :rarity_key_R=>0.2807017543859649, :rarity_key_N=>0.2982456140350877}
      def ratios_hash
        @ratios_hash ||= yield_self do
          if denominator.positive?
            StyleInfo.each_with_object({}) do |e, m|
              m[e.key] = (counts_hash[e.key] || 0).fdiv(denominator)
            end
          end
        end
      end

      # Swars::User["bsplive"].stat.style_stat_mod.denominator     # => 57
      def denominator
        @denominator ||= counts_hash.values.sum
      end

      # Swars::User["bsplive"].stat.style_stat_mod.counts_hash     # => {:rarity_key_SSR=>8, :rarity_key_SR=>16, :rarity_key_R=>16, :rarity_key_N=>17}
      def counts_hash
        raise NotImplementedError, "#{__method__} is not implemented"
      end
    end
  end
end
