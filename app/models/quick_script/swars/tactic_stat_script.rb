# frozen-string-literal: true

#
# 一次集計
# QuickScript::Swars::TacticAggregator.new.cache_write
#
module QuickScript
  module Swars
    class TacticStatScript < Base
      include LinkToNameMethods
      include ZatuyouMethods

      self.title        = "将棋ウォーズ戦法勝率ランキング"
      self.description  = "戦法・囲いなどの勝率・頻度を調べる"
      self.form_method  = :get
      self.button_label = "集計"
      self.debug_mode   = Rails.env.local?

      FREQ_RATIO_GTEQ_DEFAULT = 0.0003

      NOTE_IS_NO_SORT = false

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
                :elems   => TacticAggregator::PeriodInfo.form_part_elems,
                :default => period_info.key,
              }
            },
          },
          {
            :label        => "[勝率ランキング参加条件] 頻度N以上",
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
            :label        => "[勝率ランキング参加条件] 出現数N以上",
            :key          => :freq_count_gteq,
            :type         => debug_mode ? :numeric : :hidden,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :options => { min: 0 },
                :default => (params[:freq_count_gteq].presence || 0).to_i,
              }
            },
          },
        ]
      end

      def call
        unless aggregate
          return "一次集計データがありません"
        end
        if internal_rows.blank?
          return "一件も見つかりません"
        end
        if internal_rows.present?
          values = [
            { _component: "CustomChart", _v_bind: { params: custom_chart_params, }, style: { "max-width" => ua_info.max_width, margin: "auto" }, :class => "is-unselectable is-centered", },
            simple_table(table_rows, always_table: true),
            status,
          ]
          v_stack(values, style: { "gap" => "1rem" })
        end
      end

      def table_rows
        internal_rows.collect.with_index do |e, i|
          item = Bioshogi::Analysis::TacticInfo.flat_lookup(e[:tag_name])

          {}.tap do |row|
            win_ratio  = e[:win_ratio].try  { "%.3f" % self } || ""
            freq_ratio = e[:freq_ratio].try { "%.4f" % self } || ""
            if scope_info.key == :note && NOTE_IS_NO_SORT
            else
              row["#"] = i.next
            end
            row[scope_info.name] = row_name(item)
            if order_info.key == :win_rate
              row["勝率"] = win_ratio
              row["頻度"] = freq_ratio
            else
              row["頻度"] = freq_ratio
              row["勝率"] = win_ratio
            end
            row["WIN"]  = e[:win_count]
            row["LOSE"] = e[:lose_count]
            row["DRAW"] = e[:draw_count]
            row["出現数"] = e[:freq_count]
            row["ｽﾀｲﾙ"] = item.try { style_info.name }
            row["種類"] = item.try { human_name }

            if admin_user
              row[header_blank_column(0)] = { _nuxt_link: { name: "判定条件", to: { path: "/lab/general/encyclopedia", query: { tag: item.name }, }, }, }
              row[header_blank_column(1)] = { _nuxt_link: { name: "棋力帯",   to: { path: "/lab/swars/grade-stat",     query: { tag: item.name }, }, }, }
              row[header_blank_column(2)] = { _nuxt_link: { name: "横断検索", to: { path: "/lab/swars/cross-search",   query: { x_tags: item.name }, }, }, }
            end
          end
        end
      end

      def title
        "将棋ウォーズ#{scope_info.name}#{order_info.name}ランキング"
      end

      def internal_rows
        @internal_rows ||= aggregate2[:internal_rows]
      end

      def status
        @status ||= aggregate2[:status]
      end

      def aggregate2
        @aggregate2 ||= yield_self do
          av = period_agg[:records]
          av = scope_info.scope_block[av]

          if scope_info.key == :note && NOTE_IS_NO_SORT
            # 備考は bioshogi 側の並びに合わせるのみ
            av = av.sort_by { |e| Bioshogi::Analysis::NoteInfo[e[:tag_name]].code }
          else
            if order_info.key == :win_rate
              # 勝率条件出現数N以上
              if freq_count_gteq
                av = av.find_all { |e| e[:freq_count] >= freq_count_gteq }
              end
              # 勝率条件出現数N%以上
              if freq_ratio_gteq
                pivot = freq_ratio_gteq
                av = av.find_all { |e| e[:freq_ratio] >= pivot }
              end
            end
            # ランキング
            av = av.sort_by { |e| -e[order_info.order_by] }
          end

          {
            :internal_rows => av,
            :status => {
              "対象対局数" => period_agg[:memberships_count] / LocationInfo.count,
              "対象タグ数" => period_agg[:records].size,
            },
          }
        end
      end

      def aggregate
        @aggregate ||= TacticAggregator.new.aggregate
      end

      # 指定期間の一次集計情報
      def period_agg
        @period_agg ||= aggregate.fetch(period_info.key)
      end

      ################################################################################

      def chart_bar_max
        (params[:chart_bar_max].presence || ua_info.chart_bar_max).to_i
      end

      def custom_chart_params
        e = internal_rows.take(chart_bar_max)
        {
          data: {
            labels: e.collect { |e| e[:tag_name].tr("→ー", "↓｜").chars }, # NOTE: 配列にすることで無理矢理縦表記にする
            datasets: [
              {
                label: nil,
                data: e.collect { |e| e[order_info.order_by] },
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
        TacticAggregator::PeriodInfo.lookup_key_or_first(params[:period_key])
      end

      def period_info
        TacticAggregator::PeriodInfo.fetch(period_key)
      end

      ################################################################################

      def freq_count_gteq
        (params[:freq_count_gteq].presence || 0).to_i
      end

      def freq_ratio_gteq
        (params[:freq_ratio_gteq].presence || FREQ_RATIO_GTEQ_DEFAULT).to_f
      end

      ################################################################################

      def ua_key
        UaInfo.lookup_key_or_first(params[:user_agent_key])
      end

      def ua_info
        UaInfo.fetch(ua_key)
      end

      ################################################################################
    end
  end
end
