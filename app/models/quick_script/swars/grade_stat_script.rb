# frozen-string-literal: true

#
# 一次集計
# QuickScript::Swars::GradeAggregator.new.cache_write
#
module QuickScript
  module Swars
    class GradeStatScript < Base
      FrequencyInfo = GradeAggregator::FrequencyInfo

      self.title = "将棋ウォーズ棋力分布"
      self.description = "将棋ウォーズの棋力帯毎の偏差値を求める"
      self.form_method = :get
      self.button_label = "集計"

      def form_parts
        super + [
          {
            :label        => "絞り込み",
            :key          => :tag,
            :type         => :select,
            :dynamic_part => -> {
              {
                :elems   => [""] + Bioshogi::Analysis::TacticInfo.all_elements.sort_by { |e| -e.frequency }.pluck(:key),
                :default => params[:tag],
              }
            },
          },
        ]
      end

      def call
        unless grade_aggregate
          return "集計データがありません"
        end
        if user_total_count.zero?
          return "一人も見つかりません"
        end
        values = [
          { _component: "CustomChart", _v_bind: { params: custom_chart_params, }, style: { "max-width" => "1200px", margin: "auto" }, :class => "is-unselectable is-centered", },
          simple_table(table_rows, always_table: true),
        ]
        if Rails.env.local?
          values << status
        end
        v_stack(values, style: { "gap" => "1rem" })
      end

      def table_rows
        sd_merged_grade_infos.collect do |e|
          {}.tap do |h|
            h["棋力"] = { _nuxt_link: { name: e[:grade_info].name, to: { path: "/lab/swars/cross-search", query: { x_grade_keys: e[:grade_info].key }, }, }, }
            if Rails.env.local?
              h["階級値"] = e["階級値"]
              h["基準値"] = e["基準値"].try { "%.3f" % self }
            end
            h["偏差値"] = e["偏差値"].try { "%.0f" % self }
            h["上位"]   = e["累計相対度数"].try { "%.3f %%" % (self * 100.0) }
            h["割合"]   = e["相対度数"].try { "%.3f %%" % (self * 100.0) }
            h["人数"]   = frequency_count(:user, e[:grade_info])
            h["対局数"] = frequency_count(:membership, e[:grade_info])
          end
        end
      end

      def sd_merged_grade_infos
        @sd_merged_grade_infos ||= yield_self do
          av = grade_infos.collect do |grade_info|
            { :grade_info => grade_info, "度数" => frequency_count(:user, grade_info) }
          end
          sd_merge(av)
        end
      end

      def grade_infos
        @grade_infos ||= ::Swars::GradeInfo.find_all(&:visualize)
      end

      ################################################################################

      def status
        {
          "人数合計"   => user_total_count,
          "対局数合計" => membership_total_count,
        }
      end

      def user_total_count
        grade_infos.sum { |e| frequency_count(:user, e) }
      end

      def membership_total_count
        grade_infos.sum { |e| frequency_count(:membership, e) }
      end

      ################################################################################

      def title
        "#{super} (#{user_total_count}人)"
      end

      ################################################################################

      def sd_merge(av)
        total_count = av.sum { |e| e["度数"] }
        av = av.collect { |e| e.merge("相対度数" => e["度数"].fdiv(total_count)) }
        t = 0; av = av.collect { |e| t += e["相対度数"]; e.merge("累計相対度数" => t) }
        av = av.collect.with_index { |e, i| e.merge("階級値" => -i) }
        score_total = av.sum { |e| e["度数"] * e["階級値"] }
        score_average = score_total.fdiv(total_count)
        variance = av.sum { |e| (e["階級値"] - score_average)**2 * e["度数"] } / total_count.pred
        standard_deviation = Math.sqrt(variance)
        av = av.collect { |e| e.merge("基準値" => (e["階級値"] - score_average).fdiv(standard_deviation)) }
        standard_value_average = av.sum { |e| e["基準値"] } / av.count
        av = av.collect { |e| e.merge("偏差値" => (e["基準値"] * 10 + 50)) }
      end

      ################################################################################

      concerning :ChartMethods do
        def chart_source
          @chart_source ||= grade_infos.reverse.collect do |grade_info|
            { :name => grade_info.name, :count => frequency_count(:user, grade_info) }
          end
        end

        def custom_chart_params
          {
            data: {
              labels: chart_source.collect { |e| e[:name].remove(/[段級]/) },
              datasets: [
                { data: chart_source.collect { |e| e[:count] } },
              ],
            },
            scales_y_axes_ticks: nil,
            scales_y_axes_display: false,
          }
        end
      end

      ################################################################################

      concerning :AggregateAccessorMethods do
        # >> {user:
        # >>   {plain_counts: {九段: 1, 初段: 2},
        # >>    tag_counts:
        # >>     {力戦: {初段: 2},
        # >>      GAVA角: {九段: 1},
        # >>      手損角交換型: {九段: 1}},
        # >>    },
        # >>  membership:
        # >>   {plain_counts: {九段: 2, 初段: 2},
        # >>    tag_counts:
        # >>     {力戦: {初段: 2},
        # >>      GAVA角: {九段: 2},
        # >>      手損角交換型: {九段: 2}},
        # >>    }}
        def grade_aggregate
          @grade_aggregate ||= GradeAggregator.new.aggregate
        end

        def frequency_count(frequency_info, grade_info)
          frequency_info = FrequencyInfo.fetch(frequency_info)
          grade_info = ::Swars::GradeInfo.fetch(grade_info)
          hv = grade_aggregate[frequency_info.key]
          if current_tag
            hv = hv[:tag_counts][current_tag]
          else
            hv = hv[:plain_counts]
          end
          unless hv
            return 0
          end
          hv[grade_info.key] || 0
        end

        def current_tag
          @current_tag ||= params[:tag].presence.try { to_sym }
        end
      end
    end
  end
end
