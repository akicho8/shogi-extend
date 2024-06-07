# frozen-string-literal: true

module Swars
  module User::Stat
    class TagStat < Base
      delegate *[
        :ids_count,
      ], to: :@stat

      def initialize(stat, scope)
        super(stat)
        @scope = scope
      end

      ################################################################################

      def group_ibis?
        ratio(:"居飛車") > 0.5
      end

      def group_furi?
        ratio(:"振り飛車") > 0.5
      end

      def group_all_rounder?
        ratio(:"居飛車") > 0.25 && ratio(:"振り飛車") > 0.25
      end

      ################################################################################

      def to_chart(keys)
        if keys.any? { |e| counts_hash.has_key?(e) }
          keys.collect do |e|
            { name: e, value: count(e) }
          end
        end
      end

      ################################################################################

      def exist?(key)
        assert_key(key)
        counts_hash.has_key?(key)
      end

      def ratio(key)
        if ids_count.positive?
          count(key).fdiv(ids_count)
        else
          0
        end
      end

      def count(key)
        assert_key(key)
        counts_hash.fetch(key, 0)
      end

      def counts_hash
        @counts_hash ||= yield_self do
          s = @scope
          counts = s.all_tag_counts
          counts.each_with_object({}) { |e, m| m[e.name.to_sym] = e.count }
        end
      end

      def to_set
        @to_set ||= counts_hash.keys.to_set
      end

      def to_s
        @to_s ||= counts_hash.keys.join(",")
      end

      private

      def assert_key(key)
        if Rails.env.local?
          unless key.kind_of? Symbol
            raise "key はシンボルにすること : #{key.inspect}"
          end
          unless Bioshogi::Explain::TacticInfo.flat_lookup(key)
            raise "存在しない : #{key.inspect}"
          end
        end
      end
    end
  end
end
