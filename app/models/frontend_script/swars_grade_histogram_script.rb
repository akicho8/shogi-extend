module FrontendScript
  # http://0.0.0.0:3000/script/swars-grade-histogram.json
  class SwarsGradeHistogramScript < ::FrontendScript::Base
    self.script_name = "将棋ウォーズ段級位分布"
    self.visibility_hidden_on_menu = true

    def script_body
      {
        custom_chart_params: custom_chart_params,
        records: records,
        sample_count: records.sum { |e| e.count },
      }
    end

    # 調査対象段級位
    def grade_keys
      Swars::GradeInfo.find_all(&:visualize).collect(&:key)
    end

    # 調査対象段級位のレコード
    def grade_records
      Swars::Grade.where(key: grade_keys).reorder("")
    end

    def counts_hash
      @counts_hash ||= Rails.cache.fetch(self.class.name, :expires_in => 1.days) do
        Swars::User.group(:grade).where(grade: grade_records).count
      end
    end

    def records
      @records ||= -> {
        sdc = StandardDeviation.new(counts_hash.values)
        counts_hash.reverse_each.collect do |grade, count|
          {
            grade: grade.as_json(only: [:id, :key, :priority]),
            count: count,
            deviation_score: sdc.deviation_score(count, -1),
            ratio: sdc.appear_ratio(count),
          }
        end
      }.call
    end

    def custom_chart_params
      {
        data: {
          labels: records.collect { |e| e[:grade]["key"][0] },
          datasets: [
            {
              label: nil,
              data: records.collect { |e| e[:ratio] },
            },
          ],
        },
        scales_yAxes_ticks: {
        },
      }
    end
  end
end
