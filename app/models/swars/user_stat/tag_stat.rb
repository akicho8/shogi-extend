# frozen-string-literal: true

module Swars
  module UserStat
    class TagStat < Base
      delegate *[
        :ids_count,
      ], to: :@user_stat

      def initialize(user_stat, scope)
        super(user_stat)
        @scope = scope
      end

      ################################################################################

      def group_ibis?
        ratio(:"居飛車") > 0.5
      end

      def group_furi?
        ratio(:"振り飛車") > 0.5
      end

      def group_ar?
        ratio(:"居飛車") > 0.25 && ratio(:"振り飛車") > 0.25
      end

      ################################################################################

      def to_chart(keys)
        if keys.any? { |e| to_h.has_key?(e) }
          keys.collect do |e|
            { name: e, value: count(e) }
          end
        end
      end

      ################################################################################

      def exist?(key)
        Rails.env.local? and !key.kind_of? Symbol and raise "key はシンボルにすること : #{key.inspect}"
        to_h.has_key?(key)
      end

      def ratio(key)
        if ids_count.positive?
          count(key).fdiv(ids_count)
        else
          0
        end
      end

      def count(key)
        Rails.env.local? and !key.kind_of? Symbol and raise "key はシンボルにすること : #{key.inspect}"
        to_h.fetch(key, 0)
      end

      def to_h
        @to_h ||= yield_self do
          s = @scope
          # s = s.toryo_timeout_checkmate_only
          counts = s.all_tag_counts
          counts.each_with_object({}) { |e, m| m[e.name.to_sym] = e.count }
        end
      end

      def to_set
        @to_set ||= to_h.keys.to_set
      end

      def to_s
        @to_s ||= to_h.keys.join(",")
      end
    end
  end
end
