require "active_support/core_ext/benchmark"

module Swars
  module Histogram
    # http://localhost:3000/api/swars_histogram.json
    class Base
      CHART_BAR_MAX     = 20

      attr_accessor :params

      def initialize(params)
        @params = params
        @sample_count = 0
      end

      def as_json(*)
        Rails.cache.fetch(cache_key.join("/"), expires_in: Rails.env.production? ? cache_expires_in : 0) do
          to_h_with_processed_sec
        end
      end

      def to_h
        records_fetch

        {
          :key                 => SecureRandom.hex,
          :histogram_name      => histogram_name,
          :current_max         => current_max,
          :updated_at          => Time.current,
          :sample_count        => @sample_count,
          :cache_key           => cache_key.join("/"),
          :default_limit       => default_limit,
          :default_limit_max   => default_limit_max,
          :max_list            => max_list,
          :records             => records,
          :custom_chart_params => custom_chart_params,
        }
      end

      private

      def to_h_with_processed_sec
        hash = {}
        processed_sec = Benchmark.realtime { hash = to_h }
        hash.reverse_merge(processed_sec: processed_sec)
      end

      def records_fetch
        records
      end

      def records
        @records ||= yield_self do
          aggregate_run
          sdc = StandardDeviation.new(@counts_hash.values)
          @counts_hash.sort_by { |name, count| -count }.collect do |name, count|
            {
              :name  => name,
              :count => count,
              :ratio => sdc.appear_ratio(count),
              # :deviation_score => sdc.deviation_score(count),
            }
          end
        end
      end

      def tactic_key
        @tactic_key ||= (params[:key].presence || :attack).to_sym
      end

      def tactic_info
        Bioshogi::TacticInfo.fetch_if(tactic_key)
      end

      def histogram_name
        tactic_info.name
      end

      def current_max
        @current_max ||= yield_self do
          v = (params[:max].presence || default_limit).to_i
          if current_user && current_user.staff?
            # 制限なし
          else
            # キャッシュが死なないように max_list の項目だけ許可する
            unless max_list.include?(v)
              v = default_limit
            end
          end
          v
        end
      end

      def cache_key
        [self.class.name, tactic_key, current_max]
      end

      def aggregate_run
        # FIXME: in_batches に置き換える

        target_ids = Swars::Membership.order(id: :desc).limit(current_max).pluck(:id)

        @sample_count = target_ids.count

        s = Swars::Membership.where(id: target_ids)
        tags = s.tag_counts_on("#{tactic_key}_tags")
        @counts_hash = tags.inject({}) { |a, e| a.merge(e.name => e.count) }    # => { "棒銀" => 3, "棒金" => 4 }

        # タグにない戦法も抽出する場合
        if false
          @counts_hash = tactic_info.model.inject({}) { |a, e| a.merge(e.name => @counts_hash[e.name] || 0) } # => { "棒銀" => 3, "棒金" => 4, "風車" => 0 }
        end

        # いらんタグを消す場合
        if false
          if Rails.env.production? || Rails.env.staging? || Rails.env.test?
            Array(TagMethods.reject_tag_keys[tactic_key]).each do |e|
              @counts_hash.delete(e.to_s)
            end
          end
        end
      end

      def chart_bar_max
        (params[:chart_bar_max].presence || CHART_BAR_MAX).to_i.clamp(0, CHART_BAR_MAX)
      end

      def custom_chart_params
        # [5, 4, 3, 2, 1] => [3, 4, 5]
        e = records.take(chart_bar_max).reverse
        {
          data: {
            labels: e.collect { |e| e[:name].tr("→ー", "↓｜").chars }, # NOTE: 配列にすることで無理矢理縦表記にする
            datasets: [
              {
                label: nil,
                data: e.collect { |e| e[:count] },
              },
            ],
          },
          scales_yAxes_ticks: nil,
        }
      end

      def default_limit
        10000
      end

      def default_limit_max
        default_limit
      end

      def max_list
        if Rails.env.development?
          return [0, 1, 2, 1000, 5000, default_limit]
        end
        [1000, 5000, 10000]
      end

      def current_user
        params[:current_user]
      end

      def cache_expires_in
        2.hour
      end
    end
  end
end
