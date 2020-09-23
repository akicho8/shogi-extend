module Api
  # http://0.0.0.0:3000/api/swars_grade_histogram.json
  class SwarsGradeHistogramsController < ::Api::ApplicationController
    # Swars::Membership.where(id: Swars::Membership.order(id: :desc).limit(5000).pluck(:id)).group(:grade_id).count
    # で 15ms なので 20000 ぐらいまで一瞬
    DEFAULT_LIMIT = 10000

    def show
      @counts_hash, @updated_at = Rails.cache.fetch(cache_key, expires_in: Rails.env.production? ? 1.hour : 0) do
        [
          # Swars::User.group(:grade).where(grade: grade_records).count,
          memberships_fetch,
          Time.current,
        ]
      end

      render json: {
        :sample_count        => @counts_hash.values.sum,
        :updated_at          => @updated_at,
        :custom_chart_params => custom_chart_params,
        :records             => records,
        :sample_count        => target_ids.size,
      }
    end

    private

    def target_ids
      @target_ids ||= Swars::Membership.where(grade: grade_records).order(id: :desc).limit(current_max).pluck(:id)
    end

    def memberships_fetch
      # target_idsを副SQLにすると動かない。limitがあるとダメっぽい。なんで？
      Swars::Membership.where(id: target_ids).group(:grade).count
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
        sdc = StandardDeviation.new(@counts_hash.values)
        @counts_hash.each.collect do |grade, count|
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
