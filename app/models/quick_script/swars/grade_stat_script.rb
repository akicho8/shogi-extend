# frozen-string-literal: true
#
# 一次集計
# QuickScript::Swars::GradeStatScript.primary_aggregate_run
#
module QuickScript
  module Swars
    class GradeStatScript < Base
      self.title = "将棋ウォーズ棋力分布"
      self.description = "将棋ウォーズの棋力帯ごとの人数から偏差値を求める"
      self.form_method = :get
      self.button_label = "集計"

      class << self
        def primary_aggregate_run(options = {})
          AggregateCache[name].write PrimaryAggregator.new(options).call
        end
      end

      def form_parts
        super + [
          {
            :label        => "対象",
            :key          => :population_key,
            :type         => :radio_button,
            :elems        => PopulationInfo.to_form_elems,
            :default      => population_key,
            :session_sync => true,
          },
          {
            :label        => "絞り込み",
            :key          => :tag,
            :type         => :select,
            :elems        => [""] + [:note, :technique, :attack, :defense].flat_map { |e| Bioshogi::Explain::TacticInfo[e].model.collect(&:name) },
            :default      => params[:tag],
          },
        ]
      end

      def call
        unless aggregated_value
          return "一次集計データがありません"
        end
        if total_count.zero?
          return "一#{population_info.unit}も見つかりません"
        end
        if total_count.positive?
          values = [
            { _component: "CustomChart", _v_bind: { params: custom_chart_params, }, style: {"max-width" => "800px", margin: "auto"}, :class => "is-unselectable is-centered", },
            simple_table(table_rows, always_table: true),
            status,
          ]
          { _component: "QuickScriptViewValueAsV", _v_bind: { value: values, }, style: {"gap" => "1rem"} }
        end
      end

      def table_rows
        internal_rows.collect do |e|
          {}.tap do |h|
            h["棋力"]   = e["階級"]
            h["偏差値"] = e["偏差値"].try       { "%.0f" % self }
            h["上位"]   = e["累計相対度数"].try { "%.3f %%" % (self * 100.0) }
            h["割合"]   = e["相対度数"].try     { "%.3f %%" % (self * 100.0) }
            h["人数"]   = count_by(e["階級"], :user)
            h["対局数"] = count_by(e["階級"], :membership)
          end
        end
      end

      def aggregate
        @aggregate ||= yield_self do
          start_time = Time.current

          av = target_grades.collect do |grade|
            {
              "階級" => grade.key,
              "度数" => count_by(grade.key, population_info.key),
            }
          end

          total_count = av.sum { |e| e["度数"] }                                               # => 48014
          av = av.collect { |e| e.merge("相対度数" => e["度数"].fdiv(total_count) ) }
          t = 0; av = av.collect { |e| t += e["相対度数"]; e.merge("累計相対度数" => t) }
          av = av.collect.with_index { |e, i| e.merge("階級値" => -i) }
          score_total = av.sum { |e| e["度数"] * e["階級値"] }                                     # => 378281
          score_average = score_total.fdiv(total_count)                                          # => 7.878556254425792
          variance = av.sum { |e| (e["階級値"] - score_average)**2 * e["度数"] } / total_count.pred # => 5.099197349097279
          standard_deviation = Math.sqrt(variance)                                                  # => 2.258140241237749
          av = av.collect { |e| e.merge("基準値" => (e["階級値"] - score_average).fdiv(standard_deviation) ) }
          standard_value_average = av.sum { |e| e["基準値"] } / av.count
          av = av.collect { |e| e.merge("偏差値" => (e["基準値"] * 10 + 50)) }

          {
            :internal_rows => av,
            :status => {
              "一次集計日時" => aggregated_value[:primary_aggregated_at].try { to_time.to_fs(:distance) },
              "一次集計処理" => aggregated_value[:primary_aggregation_second].try { ActiveSupport::Duration.build(self).inspect },
              "二次集計処理" => (Time.current - start_time).try { ActiveSupport::Duration.build(self).inspect },
              "人数合計"     => aggregated_value[:total_user_count],
              "対局数合計"   => aggregated_value[:total_membership_count],
              "絞り込み"     => tag,
              "度数対象"     => population_info.name,
              "度数合計"     => total_count,
              "平均"         => score_average,
              "不偏分散"     => variance,
              "標準偏差"     => standard_deviation,
              "基準値平均"   => standard_value_average,
            },
          }
        end
      end

      def count_by(grade_key, population_key)
        aggregated_value[:counts_hash].dig(grade_key.to_sym, population_key.to_sym, (tag || :__tag_nothing__).to_sym) || 0
      end

      def aggregated_value
        @aggregated_value ||= AggregateCache[self.class.name].read
      end

      def total_count
        unless aggregated_value
          return 0
        end
        @total_count = internal_rows.sum { |e| e["度数"] }
      end

      def internal_rows
        @internal_rows ||= aggregate[:internal_rows]
      end

      def status
        @status ||= aggregate[:status]
      end

      def custom_chart_params
        e = internal_rows.reverse
        {
          data: {
            labels: e.collect { |e| e["階級"].remove(/[段級]/) },
            datasets: [
              {
                label: nil,
                data: e.collect { |e| e["度数"] },
              },
            ],
          },
          scales_y_axes_ticks: nil,
          scales_y_axes_display: false,
        }
      end

      ################################################################################

      def tag
        @tag ||= params[:tag].presence.try { to_sym }
      end

      ################################################################################

      def target_grades
        @target_grades ||= ::Swars::Grade.where(key: ::Swars::GradeInfo.find_all(&:visualize).pluck(:key))
      end

      ################################################################################

      def title
        "#{super} (#{total_count}#{population_info.unit})"
      end

      ################################################################################

      def population_key
        params[:population_key].presence || PopulationInfo.first.key
      end

      def population_info
        PopulationInfo.fetch(population_key)
      end

      ################################################################################
    end
  end
end
