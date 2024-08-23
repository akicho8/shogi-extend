# セットアップ手順
# QuickScript::Swars::TacticStatScript.write
module QuickScript
  module Swars
    class TacticStatScript < Base
      self.title = "将棋ウォーズ戦型勝率ランキング"
      self.description = "戦型・囲いなどの勝率や出現率を調べる"
      self.form_method = :get
      self.button_label = "集計"

      COUNT_GTEQ_DEFAULT = 1000

      class << self
        def write(options = {})
          TransientAggregate[name].write(aggregated_value(options))
        end

        def aggregated_value(options = {})
          start_time = Time.current

          main_scope = options[:scope] || ::Swars::Membership.all
          main_scope = main_scope.joins(:battle).where(::Swars::Battle.arel_table[:turn_max].gteq(::Swars::Config.seiritsu_gteq))
          memberships_count = main_scope.count

          sub_scope = main_scope.joins(:taggings => :tag)
          sub_scope = sub_scope.joins(:judge)
          sub_scope = sub_scope.group("tags.name")
          sub_scope = sub_scope.group("judges.key")
          coutns_hash = sub_scope.count

          # hv = { "棒銀" => { win_count: 2, lose_count: 3, draw_count: 1 } } の形に変換する

          hv = {}
          coutns_hash.each do |(tag_name, judge_key), count|
            hv[tag_name] ||= { win_count: 0, lose_count: 0, draw_count: 0 }
            hv[tag_name][:"#{judge_key}_count"] = count
          end

          # records = [ { tag_name => "棒銀", ... } ] の型に変換する

          records = hv.collect do |tag_name, e|
            freq_count     = e[:win_count] + e[:lose_count] + e[:draw_count]
            win_lose_count = e[:win_count] + e[:lose_count]
            win_ratio      = e[:win_count].fdiv(win_lose_count)
            {
              :tag_name       => tag_name,
              :win_count      => e[:win_count],
              :win_ratio      => win_ratio,
              :lose_count     => e[:lose_count],
              :draw_count     => e[:draw_count],
              :freq_count     => freq_count,
              :win_lose_count => win_lose_count, # 未使用
              :freq_ratio     => freq_count.fdiv(memberships_count),
            }
          end

          # JSON 型カラムにまとめていれる形に変換する

          {
            :primary_aggregated_at      => Time.current,
            :primary_aggregation_second => Time.current - start_time,
            :memberships_count          => memberships_count,
            :records                    => records,
          }
        end
      end

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
          {}.tap do |h|
            win_ratio  = e[:win_ratio].try  { "%.3f %%" % (self * 100.0) }
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
          av = av.find_all { |e| tactic_info.ancestor_info.model[e[:tag_name]] } # 種類別

          if tactic_info.key == :note
            # 備考は bioshogi 側の並びに合わせるのみ
            model = tactic_info.ancestor_info.model
            av = av.sort_by { |e| model[e[:tag_name]].code }
          else
            # 勝率条件出現数N以上
            if order_info.key == :win_rate
              av = av.find_all { |e| e[:freq_count] >= count_gteq }
            end
            # ランキング
            av = av.sort_by { |e| -e[order_info.order_by] }
          end

          {
            :internal_rows => av,
            :status => {
              "一次集計日時" => aggregated_value[:primary_aggregated_at].try { to_time.to_fs(:distance) },
              "一次集計処理" => aggregated_value[:primary_aggregation_second].try { seconds.inspect },
              "二次集計処理" => (Time.current - start_time).try { seconds.inspect },
              "対局数"       => aggregated_value[:memberships_count],
              "タグ総数"     => aggregated_value[:records].size,
            },
          }
        end
      end

      def aggregated_value
        @aggregated_value ||= TransientAggregate[self.class.name].read
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
