# frozen-string-literal: true

module Swars
  module User::Stat
    class TagStat < Base
      delegate *[
      ], to: :@stat

      attr_reader :scope_ext

      def initialize(stat, scope_ext)
        super(stat)
        @scope_ext = scope_ext
      end

      ################################################################################

      def to_pie_chart(keys)
        if keys.any? { |e| counts_hash.has_key?(e) }
          keys.collect do |e|
            { name: e, value: counts_hash[e] || 0 }
          end
        end
      end

      def to_win_lose_chart(tag)
        if judge_counts = to_win_lose_h(tag)
          { judge_counts: judge_counts }
        end
      end

      ################################################################################

      def counts_hash
        @counts_hash ||= inside_counts_hash.each_with_object({}) do |((tag, judge_key), count), m|
          m.update(tag => count) { |k, v1, v2| v1 + v2 }
        end
      end

      # 未使用
      def win_counts_hash
        @win_counts_hash ||= inside_counts_hash.each_with_object({}) do |((tag, judge_key), count), m|
          if judge_key == :win
            m[tag] = count
          end
        end
      end

      # 未使用
      def lose_counts_hash
        @lose_counts_hash ||= inside_counts_hash.each_with_object({}) do |((tag, judge_key), count), m|
          if judge_key == :lose
            m[tag] = count
          end
        end
      end

      # 未使用
      def draw_counts_hash
        @draw_counts_hash ||= inside_counts_hash.each_with_object({}) do |((tag, judge_key), count), m|
          if judge_key == :draw
            m[tag] = count
          end
        end
      end

      ################################################################################

      def win_count_by(tag)
        assert_tag(tag)
        win_counts_hash[tag] || 0
      end

      def lose_count_by(tag)
        assert_tag(tag)
        lose_counts_hash[tag] || 0
      end

      def draw_count_by(tag)
        assert_tag(tag)
        draw_counts_hash[tag] || 0
      end

      def to_win_lose_h(tag)
        assert_tag(tag)
        win  = inside_counts_hash[[tag, :win]]
        lose = inside_counts_hash[[tag, :lose]]
        if win || lose
          {
            :win  => win || 0,
            :lose => lose || 0,
          }
        end
      end

      ################################################################################

      def ratios_hash
        @ratios_hash ||= {}.tap do |m|
          counts_hash.each_key do |tag|
            win = inside_counts_hash[[tag, :win]] || 0
            lose = inside_counts_hash[[tag, :lose]] || 0
            denominator = win + lose
            if denominator.positive?
              m[tag] = win.fdiv(denominator)
            end
          end
        end
      end

      ################################################################################

      def to_h
        counts_hash
      end

      def tags
        @tags ||= counts_hash.keys
      end

      def to_s
        @to_s ||= counts_hash.keys.join(",")
      end

      ################################################################################

      private

      def inside_counts_hash
        @inside_counts_hash ||= yield_self do
          s = @scope_ext.ids_scope
          s = s.joins(:taggings => :tag)
          s = s.joins(:judge)
          s = s.group("tags.name")
          s = s.group("judges.key")
          s.count.transform_keys do |tag, judge_key|
            [tag.to_sym, judge_key.to_sym]
          end
        end
      end
    end
  end
end
