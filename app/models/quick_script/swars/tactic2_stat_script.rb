# frozen-string-literal: true

#
# 一次集計
# QuickScript::Swars::Tactic2StatScript.new.cache_write
# QuickScript::Swars::Tactic2StatScript.new.cache_write({}, {batch_limit: 1})
#
# http://localhost:4000/lab/swars/tactic2-stat
#
module QuickScript
  module Swars
    class Tactic2StatScript < Base
      include LinkToNameMethods
      include HelperMethods

      self.title        = "将棋ウォーズ戦法勝率ランキング"
      self.description  = "戦法・囲いなどの勝率・頻度を調べる"
      self.form_method  = :get
      self.button_label = "集計"
      self.debug_mode   = Rails.env.local? && false
      self.general_json_link_show = true

      FREQ_RATIO_GTEQ_DEFAULT = 0.0003

      def header_link_items
        super + [
          { type: "t_link_to", name: "分布図", params: { href: "/lab/swars/tactic2-stat.html", target: "_self", }, },
        ]
      end

      def form_parts
        super + [
          {
            :label        => "種類",
            :key          => :scope_key,
            :type         => :radio_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => ScopeInfo.form_part_elems,
                :default => scope_key,
              }
            },
          },
          {
            :label        => "ランキング",
            :key          => :order_key,
            :type         => :radio_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => OrderInfo.form_part_elems,
                :default => order_info.key,
              }
            },
          },
          # {
          #   :label        => "期間直近",
          #   :key          => :period_key,
          #   :type         => :radio_button,
          #   :session_sync => true,
          #   :dynamic_part => -> {
          #     {
          #       :elems   => TacticJudgeAggregator::PeriodInfo.form_part_elems,
          #       :default => period_info.key,
          #     }
          #   },
          # },
          {
            :label        => "勝率ランキング参加条件 頻度N以上",
            :key          => :freq_ratio_gteq,
            :type         => :numeric,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :options      => { min: 0, step: 0.0001 },
                :default      => freq_ratio_gteq,
                :help_message => "初期値: #{FREQ_RATIO_GTEQ_DEFAULT}",
              }
            },
          },
          {
            :label        => "表示",
            :key          => :detail_key,
            :type         => :radio_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => DetailInfo.form_part_elems,
                :default => detail_info.key,
              }
            },
          },
        ]
      end

      def as_general_json
        aggregate
      end

      def call
        simple_table(human_rows, always_table: true)
      end

      def human_rows
        current_items
      end

      def title
        "将棋ウォーズ棋力別#{scope_info.name}#{order_info.name}ランキング"
      end

      def current_items
        items = aggregate
        items = items.find_all { |e| scope_info.item_keys.include?(e[:"名前"].to_sym) }
        items = filter_by_freq(items)
        items = items.group_by { |e| e[:"棋力"].to_sym }
        items = items.transform_values { |e| e.sort_by { |e| [-e.fetch(order_info.order_by), -e.fetch(:"頻度")] } }
        top_n = items.values.collect(&:size).max or raise "must not happen"
        items = top_n.times.collect do |i|
          {}.tap do |hv|
            hv["#"] = i.next    # 正しくソートするには整数にすること
            grade_infos.each { |e| hv[head_value(e.key)] = cell_value(items.dig(e.key, i)) }
          end
        end
      end

      def head_value(grade_key)
        grade_key
      end

      def cell_value(attrs)
        if attrs
          s = []
          s << attrs[:"名前"]
          if detail_info.key == :detail
            if false
              s << "%.3f" % attrs[order_info.order_by]
            else
              OrderInfo.each do |e|
                s << "#{e.order_by}: %.4f" % attrs[e.order_by]
              end
            end
          end
          s = s.join("<br>")
          { _v_html: s }
        end
      end

      def grade_infos
        @grade_infos ||= ::Swars::GradeInfo.find_all(&:gteq10).sort_by(&:priority)
      end

      def filter_by_freq(items)
        if order_info.key == :win_rate
          if pivot = freq_ratio_gteq
            items = items.find_all { |e| e[:"頻度"] >= pivot }
          end
        end
        items
      end

      ################################################################################

      def scope_key
        ScopeInfo.lookup_key_or_first(params[:scope_key])
      end

      def scope_info
        ScopeInfo.fetch(scope_key)
      end

      ################################################################################

      def order_key
        OrderInfo.lookup_key_or_first(params[:order_key])
      end

      def order_info
        OrderInfo.fetch(order_key)
      end

      ################################################################################

      def detail_key
        DetailInfo.lookup_key_or_first(params[:detail_key])
      end

      def detail_info
        DetailInfo.fetch(detail_key)
      end

      ################################################################################

      def freq_ratio_gteq
        @freq_ratio_gteq ||= (params[:freq_ratio_gteq].presence || FREQ_RATIO_GTEQ_DEFAULT).to_f
      end

      ################################################################################

      concerning :AggregateMethods do
        include BatchMethods

        def aggregate_now
          main_counts_hash       = {} # { ["九段", "棒銀", "win"] => 個数 } を集める用
          membership_counts_hash = {} # { "九段" => 対局数, } を集める用

          progress_start(main_scope.count.ceildiv(batch_size))
          main_scope.in_batches(of: batch_size).each.with_index do |scope, batch_index|
            progress_next

            if batch_limit
              if batch_index >= batch_limit
                break
              end
            end

            scope = condition_add(scope)
            main_counts_hash.update(grade_tag_judge_from(scope)) { |_, a, b| a + b }                        # =>
            membership_counts_hash.update(scope.group(::Swars::Grade.arel_table[:key]).count) { |_, a, b| a + b } # => { "九段" => 1, ... }
          end

          hv = main_counts_hash # => { ["九段", "原始棒銀", "win"] => 1, ... }
          hv = hv.group_by { |(grade_key, tag_name, judge_key), count| [grade_key, tag_name] } # => {["九段", "原始棒銀"] => [[["九段", "原始棒銀", "win"], 1]], }
          hv = hv.transform_values { |a| a.inject(JudgeInfo.zero_default_hash) { |a, ((_, _, judge_key), count)| a.merge(judge_key.to_sym => count) } } # => {["九段", "原始棒銀"] => {win: 1, lose: 0, draw: 0}, }

          items = hv.collect { |(grade_key, tag_name), e| { grade_key: grade_key, tag_name: tag_name, **e } } # ハッシュの状態からいきなりまわしてもいいけど、わかりやすいように配列化しておく

          items = items.collect do |e|
            freq_count = e[:win] + e[:lose] + e[:draw]
            win_ratio  = e[:win].fdiv(freq_count)
            item = Bioshogi::Analysis::TacticInfo.flat_lookup(e[:tag_name])
            membership_count = membership_counts_hash[e[:grade_key]]
            {
              :"棋力"      => e[:grade_key],
              :"種類"      => item.human_name,
              :"スタイル"  => item.style_info.name,
              :"名前"      => item.name,
              :"勝率"      => win_ratio,
              :"頻度"      => freq_count.fdiv(membership_count),
              :"出現数"    => freq_count,
              **JudgeInfo.inject({}) { |a, o| a.merge(o.short_name => e[o.key]) },
            }
          end
        end

        def grade_tag_judge_from(s)
          s = s.joins(:taggings => :tag)
          s = s.joins(:judge)
          s = s.group(::Swars::Grade.arel_table[:key])
          s = s.group("tags.name")
          s = s.group("judges.key")
          s.count
        end

        def available_grades
          @available_grades ||= ::Swars::GradeInfo.find_all(&:lose_pattern)
        end

        # def available_grade_keys
        #   @available_grade_keys ||= available_grades.collect(&:key)
        # end

        def condition_add(scope)
          scope = scope.joins(:battle => [:imode, :xmode, :final], :grade => [], :judge => [])
          scope = scope.merge(::Swars::Battle.valid_match_only)
          # scope = scope.where(::Swars::Grade.arel_table[:key].eq_any(available_grade_keys)) # 10000級を除く
          # scope = scope.merge(::Swars::Battle.xmode_eq(["野良", "大会", "指導"]))           # 友達対局を除く
          scope = scope.merge(::Swars::Battle.imode_eq("通常"))                             # スプリントを除く
        end
      end
    end
  end
end
