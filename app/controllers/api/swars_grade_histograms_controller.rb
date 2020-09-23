module Api
  # http://0.0.0.0:3000/api/swars_grade_histogram.json
  class SwarsGradeHistogramsController < ::Api::ApplicationController
    # Swars::Membership.where(id: Swars::Membership.order(id: :desc).limit(5000).pluck(:id)).group(:grade_id).count
    # で 15ms なので 20000 ぐらいまで一瞬
    DEFAULT_LIMIT = 5000

    def show
      render json: Rails.cache.fetch(cache_key, expires_in: Rails.env.production? ? 1.hour : 0) {
        {
          :updated_at          => Time.current,
          :sample_count        => target_ids.size,
          :records             => records,
          :custom_chart_params => custom_chart_params,
        }
      }
    end

    private

    def target_ids
      @target_ids ||= Swars::Membership.where(grade: grade_records).order(id: :desc).limit(current_max).pluck(:id)
    end

    def counts_hash
      # target_idsを副SQLにすると動かない。limitがあるとダメっぽい。なんで？
      @counts_hash ||= Swars::Membership.where(id: target_ids).group(:grade).count
    end

    def current_max
      (params[:max].presence || DEFAULT_LIMIT).to_i.clamp(0, DEFAULT_LIMIT)
    end

    def cache_key
      [self.class.name, current_max].join("/")
    end

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
        sdc = StandardDeviation.new(counts_hash.values)
        counts_hash.each.collect do |grade, count|
          {
            grade: grade.as_json(only: [:id, :key, :priority]),
            count: count,
            ratio: sdc.appear_ratio(count),
          }
        end
      }.call
    end

    def custom_chart_params
      {
        data: {
          labels: records.reverse.collect { |e| e[:grade]["key"][0] },
          datasets: [
            {
              label: nil,
              data: records.reverse.collect { |e| e[:ratio] },
            },
          ],
        },
        scales_yAxes_ticks: {
        },
      }
    end
  end
end
