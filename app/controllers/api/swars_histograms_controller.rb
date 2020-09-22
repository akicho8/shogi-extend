module Api
  # http://0.0.0.0:3000/api/swars_histogram.json
  class SwarsHistogramsController < ::Api::ApplicationController
    def show
      counts_hash, updated_at = Rails.cache.fetch(cache_key, expires_in: 1.days) do
        [counts_hash_fetch, Time.current]
      end

      sdc = StandardDeviation.new(counts_hash.values)

      records = counts_hash.sort_by { |name, count| -count }.collect do |name, count|
        {
          :name            => name,
          :count           => count,
          :deviation_score => sdc.deviation_score(count, -1),
          :ratio           => sdc.appear_ratio(count),
        }
      end

      render json: {
        :updated_at   => updated_at,
        :tactic       => tactic_info,          # 現在選択したもの
        :tactics      => Bioshogi::TacticInfo, # 選択肢表示用
        :records      => records,
        :sample_count => counts_hash.values.sum,
      }
    end

    private

    def tactic_key
      @tactic_key ||= (params[:key].presence || :attack).to_sym
    end

    def tactic_info
      Bioshogi::TacticInfo.fetch(tactic_key)
    end

    def current_max
      [params[:max].to_i, 1000].min
    end

    def cache_key
      [self.class.name, tactic_key, current_max].join("/")
    end

    def counts_hash_fetch
      s = Swars::Membership.order(created_at: :desc).limit(current_max) # TODO: order(id: desc) とどっちが速い？
      tags = s.tag_counts_on("#{tactic_key}_tags")
      counts_hash = tags.inject({}) { |a, e| a.merge(e.name => e.count) }    # => { "棒銀" => 3, "棒金" => 4 }

      # タグにない戦法も抽出する場合
      if true
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
    end
  end
end
