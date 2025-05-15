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
      self.general_json_link_show = true

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
          simple_table(human_rows, always_table: true),
        ]
        if Rails.env.local?
          values << status
        end
        v_stack(values, style: { "gap" => "1rem" })
      end

      # http://localhost:3000/api/lab/swars/grade-stat.json?json_type=general
      def as_general_json
        rows
      end

      def human_rows
        rows.collect do |row|
          row = row.merge({
              "棋力"   => { _nuxt_link: { name: row["棋力"], to: { path: "/lab/swars/cross-search", query: { x_grade_keys: row["棋力"] }, }, }, },
              "偏差値" => row["偏差値"].try { "%.0f" % self },
              "上位"   => row["上位"].try { "%.3f %%" % (self * 100.0) },
              "割合"   => row["割合"].try { "%.3f %%" % (self * 100.0) },
            })
          if Rails.env.local?
            row["基準値"] = row["基準値"].try { "%.3f" % self }
          end
          row
        end
      end

      def rows
        sd_merged_grade_infos.collect do |e|
          {}.tap do |row|
            row["棋力"]   = e[:grade_info].name
            if Rails.env.local?
              row["階級値"] = e["階級値"]
              row["基準値"] = e["基準値"]
            end
            row["偏差値"] = e["偏差値"]
            row["上位"]   = e["累計相対度数"]
            row["割合"]   = e["相対度数"]
            row["人数"]   = frequency_count(:user, e[:grade_info])
            row["対局数"] = frequency_count(:membership, e[:grade_info])
          end
        end
      end

      def sd_merged_grade_infos
        @sd_merged_grade_infos ||= yield_self do
          av = grade_infos.collect do |grade_info|
            { :grade_info => grade_info, "度数" => frequency_count(:user, grade_info) }
          end
          StandardDeviation.call(av)
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
