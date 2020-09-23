module Api
  # http://0.0.0.0:3000/api/swars_grade_histogram.json
  class SwarsGradeHistogramsController < ::Api::ApplicationController
    def show
      @counts_hash, @updated_at = Rails.cache.fetch(self.class.name, expires_in: Rails.env.production? ? 1.days : 0) do
        [
          Swars::User.group(:grade).where(grade: grade_records).count,
          Time.current,
        ]
      end

      render json: {
        :sample_count        => @counts_hash.values.sum,
        :updated_at          => @updated_at,
        :custom_chart_params => custom_chart_params,
        :records             => records,
        :sample_count        => records.sum { |e| e[:count] },
      }
    end

    private

    # 調査対象段級位
    def grade_keys
      Swars::GradeInfo.find_all(&:visualize).collect(&:key)
    end

    # 調査対象段級位のレコード
    def grade_records
      Swars::Grade.where(key: grade_keys).reorder("")
    end

    def records
      @records ||= -> {
        sdc = StandardDeviation.new(@counts_hash.values)
        @counts_hash.reverse_each.collect do |grade, count|
          {
            grade: grade.as_json(only: [:id, :key, :priority]),
            count: count,
            # deviation_score: sdc.deviation_score(count, -1),
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
