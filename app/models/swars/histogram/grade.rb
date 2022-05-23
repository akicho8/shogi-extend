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
      if Rails.env.development?
        BATCH_SIZE = 2
      else
        BATCH_SIZE = 5000
      end

      # キャッシュ後なのでここでマージするとキャッシュしない
      def as_json(*)
        super.merge({
            :xtag_select_names => xtag_select_names,
          })
      end

      # すべてキャッシュ対象
      def to_h
        super.merge({
            :rule_key          => params[:rule_key].presence,
            :xtag              => params[:xtag].presence,
            :real_total_count  => records.sum { |e| e[:count] },
          })
      end

      private

      def histogram_name
        "棋力"
      end

      # # Swars::Membership.where(id: Swars::Membership.order(id: :desc).limit(5000).pluck(:id)).group(:grade_id).count
      # # で 15ms なので 20000 ぐらいまで一瞬
      # def target_ids
      #   @target_ids ||= yield_self do
      #     # membership.battle からルールを絞る時点で固まるため最初にIDで絞る
      #     s = Swars::Membership.all
      #     s = s.order(id: :desc)
      #     s = s.limit(current_max)
      #     s.ids
      #     # s = Swars::Membership.where(id: s.ids)
      #     # s.pluck(:id)
      #   end
      # end

      def aggregate_run
        @counts_hash = {}
        @sample_count = 0

        loop_index = 0
        loop_max = current_max.fdiv(BATCH_SIZE).ceil

        second = Benchmark.realtime do
          Swars::Membership.in_batches(of: BATCH_SIZE, order: :desc) do |s|
            if loop_index >= loop_max
              break
            end
            @sample_count += s.count
            s = condition_add(s)
            @counts_hash.update(s.group(:grade_id).count) { |_, c1, c2| c1 + c2 }
            loop_index += 1
          end
        end

        SlackAgent.notify(subject: "棋力分布実行速度", body: {
            :ms           => "%.1f s" % second,
            :current_max  => current_max,
            :BATCH_SIZE   => BATCH_SIZE,
            :loop_max     => loop_max,
            :loop_index   => loop_index,
            :sample_count => @sample_count,
          })
      end

      def cache_key
        [self.class.name, current_max, *params.values_at(:rule_key, :xtag)]
      end

      # 調査対象段級位
      def grade_infos
        Swars::GradeInfo.find_all(&:visualize)
      end

      # 調査対象段級位のレコード
      def current_grades
        Swars::Grade.where(key: grade_infos.collect(&:key))
      end

      def records
        @records ||= yield_self do
          aggregate_run
          sdc = StandardDeviation.new(@counts_hash.values)
          current_grades.collect do |grade|
            count = @counts_hash.fetch(grade.id, 0)
            {
              :grade => grade.as_json(only: [:id, :key, :priority]),
              :count => count,
              :ratio => sdc.appear_ratio(count),
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
          scales_yAxes_ticks: nil,
          scales_yAxes_display: false,
        }
      end

      def xtag_select_names
        Bioshogi::TacticInfo.all_elements.collect(&:name)
      end

      def default_limit
        50000
      end

      def max_list
        [5000, 20000, 50000]
      end

      def condition_add(s)
        # 9級から九段に絞る
        # http://localhost:3000/api/swars_histogram.json?key=grade&grade_filter=true
        if params[:grade_filter].to_s == "true"
          s = s.where(grade: current_grades.unscope(:order))
        end

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

        s
      end
    end
  end
end
