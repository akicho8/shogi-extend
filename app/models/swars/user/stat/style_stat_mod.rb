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

      def ratios_hash
        @ratios_hash ||= yield_self do
          if denominator.positive?
            StyleInfo.each_with_object({}) do |e, m|
              m[e.key] = (counts_hash[e.key] || 0).fdiv(denominator)
            end
          end
        end
      end

      def denominator
        @denominator ||= counts_hash.values.sum
      end

      # 必要なのはこのメソッドだけ
      def counts_hash
        raise NotImplementedError, "#{__method__} is not implemented"
      end
    end
  end
end
