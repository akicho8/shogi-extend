# セットアップ手順
#
# Swars::TagJudgeItem.create_new_generation_items
# または
# Swars::TagJudgeItem.create_new_generation_items(scope: Swars::User["BOUYATETSU5"].memberships)
#
module QuickScript
  module Swars
    class TacticStatScript < Base
      self.title = "将棋ウォーズ戦型勝率ランキング"
      self.description = "戦型・囲いなどの勝率や出現率を調べる"
      self.form_method = :get
      self.button_label = "集計"

      COUNT_GTEQ_DEFAULT = 1000

      def form_parts
        super + [
          {
            :label        => "種類",
            :key          => :tactic_key,
            :type         => :radio_button,
            :elems        => TacticInfo.to_form_elems,
            :default      => tactic_key,
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
            :label        => "[勝率条件] 出現数N以上",
            :key          => :count_gteq,
            :type         => :integer,
            :default      => count_gteq,
            :session_sync => true,
          },
        ]
      end

      def call
        if total_count.zero?
          return "一件も見つかりません"
        end
        if total_count.positive?
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
          {}.tap do |h|
            win_ratio   = e[:win_ratio].try   { "%.3f %%" % (self * 100.0) }
            freq_ratio = e[:freq_ratio].try { "%.3f %%" % (self * 100.0) }
            if tactic_info.key != :note
              h["#"] = i.next
            end
            h[tactic_info.name] = e[:tag_name]
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
          end
        end
      end

      def title
        "将棋ウォーズ#{tactic_info.name}#{order_info.name}ランキング"
      end

      def total_count
        @total_count = internal_rows.sum { |e| e[:freq_count] }
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

          total_count = db_latest_items.sum(&:freq_count)

          list = db_latest_items.collect do |e|
            {
              :tag_name   => e.tag_name,
              :win_ratio  => e.win_count.fdiv(e.win_lose_count), # 引き分けを除く
              :win_count  => e.win_count,
              :lose_count => e.lose_count,
              :draw_count => e.draw_count,
              :freq_count => e.freq_count,
              :freq_ratio => e.freq_count.fdiv(total_count),
            }
          end

          list = list.find_all { |e| e[:freq_count] >= count_gteq }
          list = list.find_all { |e| tactic_info.ancestor_info.model[e[:tag_name]] }

          if tactic_info.key == :note
            model = tactic_info.ancestor_info.model
            list = list.sort_by { |e| model[e[:tag_name]].code }
          else
            list = list.sort_by { |e| -e[order_info.order_by] }
          end

          {
            :internal_rows => list,
            :status => {
              "一次集計日時"     => ::Swars::TagJudgeItem.db_latest_created_at.try { to_fs(:distance) },
              "二次集計処理(秒)" => Time.current - start_time,
              "サンプル総数"     => total_count,
              "タグ総数"         => db_latest_items.size,
            },
          }
          # end
        end
      end

      def db_latest_items
        @db_latest_items ||= ::Swars::TagJudgeItem.db_latest_items
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

      def tactic_key
        params[:tactic_key].presence || :attack
      end

      def tactic_info
        TacticInfo.fetch(tactic_key)
      end

      ################################################################################

      def order_key
        params[:order_key]
      end

      def order_info
        OrderInfo.lookup(order_key) || OrderInfo.first
      end

      ################################################################################

      def ua_key
        params[:user_agent_key].presence || :mobile
      end

      def ua_info
        UaInfo.fetch(ua_key)
      end

      ################################################################################

      def count_gteq
        (params[:count_gteq] || COUNT_GTEQ_DEFAULT).to_i
      end

      ################################################################################
    end
  end
end
