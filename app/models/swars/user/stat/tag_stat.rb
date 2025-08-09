# frozen-string-literal: true

module Swars
  module User::Stat
    class TagStat < Base
      WIN_THRESHOLD = 0.65

      class << self
        def report(options = {})
          options = {
            :user_keys  => User::Vip.auto_crawl_user_keys,
            :sample_max => 200,
          }.merge(options)

          options[:user_keys].collect { |user_key|
            if user = User[user_key]
              tag_stat = user.stat(options).tag_stat
              {
                :user_key          => user.key,
                "無理攻めペナ"     => tag_stat.reckless_attack_level,
                "全駒全ブッチ効果" => tag_stat.ratios_hash[:"大駒全ブッチ"].try { "%.2f" % self },
                "全駒全ブッチ"     => tag_stat.win_count_diff(:"大駒全ブッチ"),
              }
            end
          }.compact.sort_by { |e| -e["無理攻めペナ"].to_f }
        end
      end

      delegate *[
        :ids_scope,
        :ids_count,
      ], to: :scope_ext

      attr_reader :scope_ext

      def initialize(stat, scope_ext)
        super(stat)
        @scope_ext = scope_ext
      end

      ################################################################################

      # 使用率
      def use_rate_for(key)
        if ids_count.positive?
          count_by(key).fdiv(ids_count)
        end
      end

      ################################################################################

      # Swars::User["chrono_"].stat(sample_max: 1000).op_tag_stat.to_win_lose_h(:"角不成", swap: true)   # => {:win=>9, :lose=>4}
      # Swars::User["chrono_"].stat(sample_max: 1000).op_tag_stat.to_win_lose_h(:"飛車不成", swap: true) # => {:win=>2, :lose=>3}
      # Swars::User["chrono_"].stat(sample_max: 1000).op_tag_stat.lose_with?(:"角不成")                   # => true
      # Swars::User["chrono_"].stat(sample_max: 1000).op_tag_stat.win_with?(:"角不成")                    # => false
      # Swars::User["chrono_"].stat(sample_max: 1000).op_tag_stat.lose_with?(:"飛車不成")                 # => false
      # Swars::User["chrono_"].stat(sample_max: 1000).op_tag_stat.win_with?(:"飛車不成")                  # => true

      # これを使うよりは win_stat を使った方が早い
      def master_of(tag, threshold: WIN_THRESHOLD)
        assert_tag(tag)
        if v = ratios_hash[tag]
          v >= threshold
        end
      end

      def win_ratio_lt(tag, threshold)
        assert_tag(tag)
        if v = ratios_hash[tag]
          v < threshold
        end
      end

      # tag を使ってトータルで勝ち越した
      def win_with?(tag, threshold = 0.5)
        assert_tag(tag)
        if v = ratios_hash[tag]
          v > threshold
        end
      end

      # tag を使ってトータルで負け越した
      def lose_with?(tag, threshold = 0.5)
        assert_tag(tag)
        if v = ratios_hash[tag]
          v < threshold
        end
      end

      ################################################################################

      # 無理攻めの度合い
      def reckless_attack_level
        tag = :"大駒全ブッチ"
        if count_by(tag) >= Config.master_count_gteq
          diff = win_count_diff(tag)
          if diff.negative?
            -diff
          end
        end
      end

      def win_count_diff(tag)
        win_count_by(tag) - lose_count_by(tag)
      end

      ################################################################################

      def to_pie_chart(keys)
        if keys.any? { |e| counts_hash.has_key?(e) }
          keys.collect do |e|
            { name: e, value: counts_hash[e] || 0 }
          end
        end
      end

      def to_win_lose_chart(tag, options = {})
        if judge_counts = to_win_lose_h(tag, options)
          { judge_counts: judge_counts }
        end
      end

      ################################################################################

      def counts_hash
        @counts_hash ||= internal_counts_hash.each_with_object({}) do |((tag, judge_key), count), m|
          m.update(tag => count) { |k, v1, v2| v1 + v2 }
        end
      end

      def win_counts_hash
        @win_counts_hash ||= internal_counts_hash.each_with_object({}) do |((tag, judge_key), count), m|
          if judge_key == :win
            m[tag] = count
          end
        end
      end

      # 未使用
      def lose_counts_hash
        @lose_counts_hash ||= internal_counts_hash.each_with_object({}) do |((tag, judge_key), count), m|
          if judge_key == :lose
            m[tag] = count
          end
        end
      end

      # 未使用
      def draw_counts_hash
        @draw_counts_hash ||= internal_counts_hash.each_with_object({}) do |((tag, judge_key), count), m|
          if judge_key == :draw
            m[tag] = count
          end
        end
      end

      ################################################################################

      def count_by(tag)
        assert_tag(tag)
        counts_hash[tag] || 0
      end

      def win_count_by(tag)
        assert_tag(tag)
        win_counts_hash[tag] || 0
      end

      # 未使用
      def lose_count_by(tag)
        assert_tag(tag)
        lose_counts_hash[tag] || 0
      end

      # 未使用
      def draw_count_by(tag)
        assert_tag(tag)
        draw_counts_hash[tag] || 0
      end

      def to_win_lose_h(tag, options = {})
        assert_tag(tag)
        win  = internal_counts_hash[[tag, :win]]
        lose = internal_counts_hash[[tag, :lose]]
        if win || lose
          if options[:swap]
            win, lose = lose, win
          end
          {
            :win  => win || 0,
            :lose => lose || 0,
          }
        end
      end

      def win_lose_sum(tag)
        assert_tag(tag)
        win  = internal_counts_hash[[tag, :win]] || 0
        lose = internal_counts_hash[[tag, :lose]] || 0
        win + lose
      end

      ################################################################################

      def ratios_hash
        @ratios_hash ||= {}.tap do |m|
          counts_hash.each_key do |tag|
            win = internal_counts_hash[[tag, :win]] || 0
            lose = internal_counts_hash[[tag, :lose]] || 0
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
      prepend TagMethods

      ################################################################################

      def tag_chart_build(tag, options = {})
        options = {
          :swap => false,
        }.merge(options)

        if judge_counts = to_win_lose_h(tag, options)
          appear_ratio = win_lose_sum(tag).fdiv(ids_count)
          {
            :tag          => tag,          # 戦法名
            :appear_ratio => appear_ratio, # 遭遇率 (なくてもいい)
            :judge_counts => judge_counts, # 勝敗数
          }
        end
      end

      ################################################################################

      private

      def internal_counts_hash
        @internal_counts_hash ||= yield_self do
          s = ids_scope
          s = s.joins(:taggings => :tag)
          s = s.joins(:judge)
          s = s.group("tags.name")
          s = s.group("judges.key")
          s.count.transform_keys { |e| e.collect(&:to_sym) }
        end
      end
    end
  end
end
