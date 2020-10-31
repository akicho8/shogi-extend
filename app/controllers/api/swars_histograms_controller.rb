module Api
  # http://0.0.0.0:3000/api/swars_histogram.json
  class SwarsHistogramsController < ::Api::ApplicationController
    DEFAULT_LIMIT     = 1000
    DEFAULT_LIMIT_MAX = 10000
    CHART_BAR_MAX     = 20

    def show
      render json: Rails.cache.fetch(cache_key, expires_in: Rails.env.production? ? 1.day : 0) {
        {
          :key                 => SecureRandom.hex,
          :current_max         => current_max,
          :updated_at          => Time.current,
          :sample_count        => target_ids.size,
          :tactic              => tactic_info,
          :records             => records,
          :custom_chart_params => custom_chart_params,
        }
      }
    end

    private

    def records
      @records ||= -> {
        sdc = StandardDeviation.new(counts_hash.values)
        counts_hash.sort_by { |name, count| -count }.collect do |name, count|
          {
            :name  => name,
            :count => count,
            :ratio => sdc.appear_ratio(count),
          }
        end
      }.call
    end

    def tactic_key
      @tactic_key ||= (params[:key].presence || :attack).to_sym
    end

    def tactic_info
      Bioshogi::TacticInfo.fetch(tactic_key)
    end

    def current_max
      (params[:max].presence || DEFAULT_LIMIT).to_i.clamp(0, DEFAULT_LIMIT_MAX)
    end

    def cache_key
      [self.class.name, tactic_key, current_max].join("/")
    end

    def target_ids
      @target_ids ||= Swars::Membership.order(id: :desc).limit(current_max).pluck(:id)
    end

    def counts_hash
      @counts_hash ||= -> {
        s = Swars::Membership.where(id: target_ids)
        tags = s.tag_counts_on("#{tactic_key}_tags")
        counts_hash = tags.inject({}) { |a, e| a.merge(e.name => e.count) }    # => { "棒銀" => 3, "棒金" => 4 }

        # タグにない戦法も抽出する場合
        if false
          counts_hash = tactic_info.model.inject({}) { |a, e| a.merge(e.name => counts_hash[e.name] || 0) } # => { "棒銀" => 3, "棒金" => 4, "風車" => 0 }
        end

        # いらんタグを消す場合
        if false
          if Rails.env.production? || Rails.env.staging? || Rails.env.test?
            Array(TagMod.reject_tag_keys[tactic_key]).each do |e|
              counts_hash.delete(e.to_s)
            end
          end
        end

        counts_hash
      }.call
    end

    def chart_bar_max
      (params[:chart_bar_max].presence || CHART_BAR_MAX).to_i.clamp(0, CHART_BAR_MAX)
    end

    def custom_chart_params
      # [5, 4, 3, 2, 1] => [3, 4, 5]
      e = records.take(chart_bar_max).reverse
      {
        data: {
          labels: e.collect { |e| e[:name].tr("→ー", "↓｜").chars },
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
  end
end
