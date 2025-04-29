# frozen-string-literal: true

#
# 一次集計
# QuickScript::Swars::TacticJudgeAggregator.new.cache_write
#
module QuickScript
  module Swars
    class TacticStatScript < Base
      include LinkToNameMethods
      include HelperMethods

      self.title        = "将棋ウォーズ戦法勝率ランキング"
      self.description  = "戦法・囲いなどの勝率・頻度を調べる"
      self.form_method  = :get
      self.button_label = "集計"
      self.debug_mode   = Rails.env.local?

      FREQ_RATIO_GTEQ_DEFAULT = 0.0003

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
          {
            :label        => "期間直近",
            :key          => :period_key,
            :type         => :radio_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => TacticJudgeAggregator::PeriodInfo.form_part_elems,
                :default => period_info.key,
              }
            },
          },
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
        ]
      end

      def call
        unless aggregate
          return "一次集計データがありません"
        end
        if current_items.blank?
          return "一件も見つかりません"
        end
        if current_items.present?
          values = [
            { _component: "CustomChart", _v_bind: { params: custom_chart_params }, style: { "max-width" => ua_info.max_width, margin: "auto" }, :class => "is-unselectable is-centered" },
            simple_table(table_rows, always_table: true),
          ]
          if Rails.env.local?
            values << status
          end
          v_stack(values, style: { "gap" => "1rem" })
        end
      end

      def table_rows
        current_items.collect.with_index do |e, i|
          {}.tap do |row|
            row["#"] = i.next
            row[scope_info.name] = row_name(e.info)
            row["勝率"] = e.win_ratio.try { "%.3f" % self } || ""
            row["頻度"] = e.freq_ratio.try { "%.4f" % self }

            row["WIN"]  = e.win_count
            row["LOSE"] = e.lose_count
            row["DRAW"] = e.draw_count

            row["出現数"] = e.freq_count || 0
            row["ｽﾀｲﾙ"]   = e.style_name
            row["種類"]   = e.info.human_name

            row[header_blank_column(0)] = { _nuxt_link: { name: "判定局面", to: { path: "/lab/general/encyclopedia", query: { tag: e.info.name }, }, }, }
            row[header_blank_column(1)] = { _nuxt_link: { name: "棋力帯",   to: { path: "/lab/swars/grade-stat",     query: { tag: e.info.name }, }, }, }
            row[header_blank_column(2)] = { _nuxt_link: { name: "横断検索", to: { path: "/lab/swars/cross-search",   query: { x_tags: e.info.name }, }, }, }
          end
        end
      end

      def title
        "将棋ウォーズ#{scope_info.name}#{order_info.name}ランキング"
      end

      def status
        @status ||= {
          "対象対局数" => period_agg[:memberships_count] / LocationInfo.count,
          "対象タグ数" => period_agg[:records].size,
        }
      end

      def current_items
        @current_items ||= yield_self do
          items = scope_info.target_infos.collect { |e| Item[info: e, stat: period_agg_hash[e.key] || {}] }
          items = fliter_process(items)
          items = items.sort_by { |e| -(e.public_send(order_info.order_by) || -1) }
        end
      end

      def fliter_process(items)
        if order_info.key == :win_rate
          # 勝率条件出現数N%以上
          if freq_ratio_gteq
            pivot = freq_ratio_gteq
            items = items.find_all { |e| e.freq_ratio >= pivot }
          end
        end
        items
      end

      def aggregate
        @aggregate ||= TacticJudgeAggregator.new.aggregate
      end

      # 指定期間の一次集計情報
      def period_agg
        @period_agg ||= aggregate.fetch(period_info.key)
      end

      def period_agg_hash
        @period_agg_hash ||= period_agg[:records].inject({}) { |a, e| a.merge(e[:tag_name].to_sym => e) }
      end

      ################################################################################

      def chart_bar_max
        (params[:chart_bar_max].presence || ua_info.chart_bar_max).to_i
      end

      def custom_chart_params
        items = current_items.take(chart_bar_max)
        {
          data: {
            labels: items.collect { |e| e.info.name.tr("→ー", "↓｜").chars }, # NOTE: 配列にすることで無理矢理縦表記にする
            datasets: [
              {
                label: nil,
                data: items.collect { |e| e.public_send(order_info.order_by) || 0.0 },
              },
            ],
          },
          scales_y_axes_ticks: nil,
          scales_y_axes_display: false,
          aspect_ratio: ua_info.aspect_ratio,
        }
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

      def period_key
        TacticJudgeAggregator::PeriodInfo.lookup_key_or_first(params[:period_key])
      end

      def period_info
        TacticJudgeAggregator::PeriodInfo.fetch(period_key)
      end

      ################################################################################

      def freq_ratio_gteq
        @freq_ratio_gteq ||= (params[:freq_ratio_gteq].presence || FREQ_RATIO_GTEQ_DEFAULT).to_f
      end

      ################################################################################

      def ua_key
        UaInfo.lookup_key_or_first(params[:user_agent_key])
      end

      def ua_info
        UaInfo.fetch(ua_key)
      end

      ################################################################################

      Item = Data.define(:info, :stat) do
        def initialize(info:, stat:)
          stat ||= {}
          super
        end

        # sort 用
        def win_ratio
          stat[:win_ratio]
        end

        # sort 用
        def freq_count
          stat[:freq_count]
        end

        def freq_ratio
          stat[:freq_ratio] || 0.0
        end

        def win_count
          stat[:win_count] || 0
        end

        def lose_count
          stat[:lose_count] || 0
        end

        def draw_count
          stat[:draw_count] || 0
        end

        def style_name
          info.style_info.name
        end
      end
    end
  end
end
