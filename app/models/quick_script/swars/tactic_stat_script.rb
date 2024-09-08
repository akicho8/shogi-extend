# frozen-string-literal: true
#
# 一次集計
# QuickScript::Swars::TacticStatScript.primary_aggregate_run
#
module QuickScript
  module Swars
    class TacticStatScript < Base
      self.title = "将棋ウォーズ戦法勝率ランキング"
      self.description = "戦法・囲いなどの勝率・頻度を調べる"
      self.form_method = :get
      self.button_label = "集計"
      self.debug_mode = Rails.env.local?

      class << self
        def primary_aggregate_run(options = {})
          AggregateCache[name].write PrimaryAggregator.new(options).call
        end
      end

      def form_parts
        super + [
          {
            :label        => "種類",
            :key          => :scope_key,
            :type         => :radio_button,
            :elems        => ScopeInfo.to_form_elems,
            :default      => scope_key,
            :session_sync => true,
          },
          {
            :label        => "ランキング",
            :key          => :order_key,
            :type         => :radio_button,
            :elems        => OrderInfo.to_form_elems,
            :default      => order_info.key,
            :session_sync => true,
          },
          {
            :label        => "[勝率ランキング参加条件] 出現率N%以上",
            :key          => :freq_ratio_gteq,
            :type         => :numeric,
            :options      => { min: 0, step: 0.01 },
            :default      => freq_ratio_gteq,
            :session_sync => true,
          },
          {
            :label        => "[勝率ランキング参加条件] 出現数N以上",
            :key          => :freq_count_gteq,
            :type         => debug_mode ? :numeric : :hidden,
            :default      => params[:freq_count_gteq],
            :session_sync => true,
          },
        ]
      end

      def call
        unless aggregated_value
          return "一次集計データがありません"
        end
        if internal_rows.blank?
          return "一件も見つかりません"
        end
        if internal_rows.present?
          values = [
            { _component: "CustomChart", _v_bind: { params: custom_chart_params, }, style: {"max-width" => ua_info.max_width, margin: "auto"}, :class => "is-unselectable is-centered", },
            simple_table(table_rows, always_table: true),
            status,
          ]
          { _component: "QuickScriptViewValueAsV", _v_bind: { value: values, }, style: {"gap" => "1rem"} }
        end
      end

      def table_rows
        internal_rows.collect.with_index do |e, i|
          item = Bioshogi::Explain::TacticInfo.flat_lookup(e[:tag_name])

          {}.tap do |h|
            win_ratio  = e[:win_ratio].try  { "%.3f %%" % (self * 100.0) }
            freq_ratio = e[:freq_ratio].try { "%.3f %%" % (self * 100.0) }
            if scope_info.key != :note
              h["#"] = i.next
            end
            h[scope_info.name] = e[:tag_name]
            if order_info.key == :win_rate
              h["勝率"]     = win_ratio
              h["出現率"] = freq_ratio
            else
              h["出現率"] = freq_ratio
              h["勝率"]     = win_ratio
            end
            h["WIN"]    = e[:win_count]
            h["LOSE"]   = e[:lose_count]
            h["DRAW"]   = e[:draw_count]
            h["出現数"] = e[:freq_count]
            h["スタイル"] = item.try { style_info.name }
            h["種類"]     = item.try { self.class.human_name }
            if admin_user
              h["リンク1"]  = { _nuxt_link: { name: "棋力帯",       to: {path: "/lab/swars/grade-stat",       query: { tag: e[:tag_name], }, }, }, }
              h["リンク2"]  = { _nuxt_link: { name: "戦法ミニ事典", to: {path: "/lab/general/encyclopedia",   query: { tag: e[:tag_name], }, }, }, }
              h["リンク3"]  = { _nuxt_link: { name: "採用者を探す", to: {path: "/lab/swars/cross-search", query: { tag: e[:tag_name], }, }, }, }
            end
          end
        end
      end

      def title
        "将棋ウォーズ#{scope_info.name}#{order_info.name}ランキング"
      end

      def internal_rows
        @internal_rows ||= aggregate[:internal_rows]
      end

      def status
        @status ||= aggregate[:status]
      end

      def aggregate
        @aggregate ||= yield_self do
          start_time = Time.current

          av = aggregated_value[:records]
          av = scope_info.scope_block[av]

          if scope_info.key == :note
            # 備考は bioshogi 側の並びに合わせるのみ
            av = av.sort_by { |e| Bioshogi::Explain::NoteInfo[e[:tag_name]].code }
          else
            if order_info.key == :win_rate
              # 勝率条件出現数N以上
              if freq_count_gteq
                av = av.find_all { |e| e[:freq_count] >= freq_count_gteq }
              end
              # 勝率条件出現数N%以上
              if freq_ratio_gteq
                pivot = freq_ratio_gteq.fdiv(100)
                av = av.find_all { |e| e[:freq_ratio] >= pivot }
              end
            end
            # ランキング
            av = av.sort_by { |e| -e[order_info.order_by] }
          end

          {
            :internal_rows => av,
            :status => {
              "一次集計日時" => aggregated_value[:primary_aggregated_at].try { to_time.to_fs(:distance) },
              "一次集計処理" => aggregated_value[:primary_aggregation_second].try { ActiveSupport::Duration.build(self).inspect },
              "二次集計処理" => (Time.current - start_time).then { |e| ActiveSupport::Duration.build(e).inspect },
              "対局数"       => aggregated_value[:population_count],
              "タグ総数"     => aggregated_value[:records].size,
            },
          }
        end
      end

      def aggregated_value
        @aggregated_value ||= AggregateCache[self.class.name].read
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
        ScopeInfo.valid_key_or_first(params[:scope_key])
      end

      def scope_info
        ScopeInfo.fetch(scope_key)
      end

      ################################################################################

      def order_key
        OrderInfo.valid_key_or_first(params[:order_key])
      end

      def order_info
        OrderInfo.fetch(order_key)
      end

      ################################################################################

      def freq_count_gteq
        params[:freq_count_gteq].presence.try { to_i }
      end

      def freq_ratio_gteq
        (params[:freq_ratio_gteq].presence || 0.03).to_f
      end

      ################################################################################

      def ua_key
        UaInfo.valid_key_or_first(params[:user_agent_key])
      end

      def ua_info
        UaInfo.fetch(ua_key)
      end

      ################################################################################
    end
  end
end
