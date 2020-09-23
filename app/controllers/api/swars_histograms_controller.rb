module Api
  # http://0.0.0.0:3000/api/swars_histogram.json
  class SwarsHistogramsController < ::Api::ApplicationController
    DEFAULT_LIMIT = 1000

    def show
      render json: Rails.cache.fetch(cache_key, expires_in: Rails.env.production? ? 1.hours : 0) {
        {
          :updated_at   => Time.current,
          :sample_count => target_ids.size,
          :tactic       => tactic_info,
          :records      => records,
        }
      }
    end

    private

    def records
      sdc = StandardDeviation.new(counts_hash.values)
      counts_hash.sort_by { |name, count| -count }.collect do |name, count|
        {
          :name  => name,
          :count => count,
          :ratio => sdc.appear_ratio(count),
        }
      end
    end

    def tactic_key
      @tactic_key ||= (params[:key].presence || :attack).to_sym
    end

    def tactic_info
      Bioshogi::TacticInfo.fetch(tactic_key)
    end

    def current_max
      (params[:max].presence || DEFAULT_LIMIT).to_i.clamp(0, DEFAULT_LIMIT)
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
  end
end
