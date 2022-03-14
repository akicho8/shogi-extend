# 将棋ウォーズ棋力分布
#
# experiment/swars/棋力ヒストグラム.rb
# app/models/swars/histogram/grade.rb
# nuxt_side/pages/swars/histograms/grade.vue
#
# API
# http://localhost:3000/api/swars_histogram.json?key=grade
# http://localhost:3000/api/swars_histogram.json?key=grade&xtag=新嬉野流
#
# WEB
# http://localhost:4000/swars/histograms/grade?max=10000

module Swars
  module Histogram
    class Grade < Base
      def to_h
        super.merge({
            :rule_key  => params[:rule_key].presence,
            :xtag      => params[:xtag].presence,
            :xtag_select_names => xtag_select_names,
          })
      end

      private

      def histogram_name
        "棋力"
      end

      # Swars::Membership.where(id: Swars::Membership.order(id: :desc).limit(5000).pluck(:id)).group(:grade_id).count
      # で 15ms なので 20000 ぐらいまで一瞬
      def target_ids
        @target_ids ||= yield_self do
          s = Swars::Membership.all

          if Rails.env.development?
            # http://localhost:3000/api/swars_histogram.json?key=grade&rule_key=ten_min
            # http://localhost:3000/api/swars_histogram.json?key=grade&rule_key=three_min
            if e = RuleInfo.lookup(params[:rule_key].presence)
              s = s.rule_eq(e)
            end

            # http://localhost:3000/api/swars_histogram.json?key=grade&xtag=新嬉野流
            # http://localhost:3000/api/swars_histogram.json?key=grade&xtag=嬉野流
            if v = params[:xtag].to_s.split(/[,\s]+/).presence
              s = s.tagged_with(v)
            end
          end

          s = s.where(grade: grade_records) # 9級から九段に絞る
          s = s.limit(current_max)
          s = s.order(id: :desc)

          s.pluck(:id)
        end
      end

      def counts_hash
        # target_idsを副SQLにすると動かない。limitがあるとダメっぽい。なんで？
        @counts_hash ||= Swars::Membership.where(id: target_ids).group(:grade).count
      end

      def cache_key
        [self.class.name, current_max, *params.values_at(:rule_key, :xtag)]
      end

      # 調査対象段級位
      def grade_keys
        Swars::GradeInfo.find_all(&:visualize).collect(&:key)
      end

      # 調査対象段級位のレコード
      def grade_records
        Swars::Grade.where(key: grade_keys).unscope(:order)
      end

      def records
        @records ||= yield_self do
          sdc = StandardDeviation.new(counts_hash.values)
          counts_hash.each.collect do |grade, count|
            {
              :grade => grade.as_json(only: [:id, :key, :priority]),
              :count => count,
              :ratio => sdc.appear_ratio(count),
              # :deviation_score => sdc.deviation_score(count),
            }
          end
        end
      end

      def custom_chart_params
        e = records.reverse
        {
          data: {
            labels: e.collect { |e| e[:grade]["key"][0] },
            datasets: [
              {
                label: nil,
                data: e.collect { |e| e[:count] },
              },
            ],
          },
          scales_yAxes_ticks: {
          },
        }
      end

      def xtag_select_names
        Bioshogi::TacticInfo.all_elements.collect(&:name)
      end

      def default_limit
        20000
      end

      def default_limit_max
        50000
      end

      def max_list
        # if Rails.env.development?
        #   return [0, 1, 2, 1000, 5000, 20000]
        # end
        [1000, 10000, 20000]
      end
    end
  end
end
