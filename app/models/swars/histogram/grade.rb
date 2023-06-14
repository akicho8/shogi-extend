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
      # キャッシュ後なのでここでマージするとキャッシュしない
      def as_json(*)
        super.merge({
            :xtag_select_names => xtag_select_names,
          })
      end

      # すべてキャッシュ対象
      def to_h
        super.merge({
            :rule_key  => params[:rule_key].presence,
            :xtag      => params[:xtag].presence,
            "平均"     => @score_average,
            "標準偏差" => @standard_deviation,
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

      def aggregate_core
        loop_index = 0
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

          # sdc = StandardDeviation.new(@counts_hash.values)
          # :ratio => sdc.appear_ratio(count),

          list = current_grades.collect do |grade|
            count = @counts_hash.fetch(grade.id, 0)
            {
              "階級" => grade.key,
              "度数" => count,
            }
          end

          if Rails.env.development?
            list = list.collect { |e| e.merge("度数" => categoy_data_for_development[e["階級"]] || 0) }
          end

          frequency_total = list.sum { |e| e["度数"] }                                               # => 48014
          list = list.collect { |e| e.merge("相対度数" => e["度数"].fdiv(frequency_total) ) }
          t = 0; list = list.collect { |e| t += e["相対度数"]; e.merge("上位" => t) }
          list = list.collect.with_index { |e, i| e.merge("階級値" => -i) }
          score_total = list.sum { |e| e["度数"] * e["階級値"] }                                     # => 378281
          @score_average = score_total.fdiv(frequency_total)                                          # => 7.878556254425792
          variance = list.sum { |e| (e["階級値"] - @score_average)**2 * e["度数"] } / frequency_total # => 5.099197349097279
          @standard_deviation = Math.sqrt(variance)                                                  # => 2.258140241237749
          list = list.collect { |e| e.merge("基準値" => (e["階級値"] - @score_average).fdiv(@standard_deviation) ) }
          list = list.collect { |e| e.merge("偏差値" => (e["基準値"] * 10 + 50)) }
        end
      end

      def custom_chart_params
        e = records.reverse
        {
          data: {
            labels: e.collect { |e| e["階級"][0] },
            datasets: [
              {
                label: nil,
                data: e.collect { |e| e["度数"] },
              },
            ],
          },
          scales_yAxes_ticks: nil,
          scales_yAxes_display: false,
        }
      end

      def xtag_select_names
        Bioshogi::Explain::TacticInfo.all_elements.collect(&:name)
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
        if v = rule_info
          s = s.rule_eq(v)
        end

        # http://localhost:3000/api/swars_histogram.json?key=grade&xtag=新嬉野流
        # http://localhost:3000/api/swars_histogram.json?key=grade&xtag=嬉野流
        if v = xtag
          s = s.tagged_with(v)
        end

        s
      end

      def xtag
        @xtag ||= params[:xtag].to_s.split(/[,\s]+/).presence
      end

      def rule_info
        @rule_info ||= RuleInfo.lookup(params[:rule_key])
      end

      def categoy_data_for_development
        {
          "九段" => 22,
          "八段" => 39,
          "七段" => 141,
          "六段" => 444,
          "五段" => 549,
          "四段" => 1163,
          "三段" => 2927,
          "二段" => 5032,
          "初段" => 7843,
          "1級" =>  9562,
          "2級" =>  8249,
          "3級" =>  5650,
          "4級" =>  3149,
          "5級" =>  1743,
          "6級" =>  754,
          "7級" =>  353,
          "8級" =>  153,
          "9級" =>  92,
        }
      end
    end
  end
end
