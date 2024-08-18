module Swars
  module Histogram
    # http://localhost:3000/api/swars_histogram.json
    class Base
      BATCH_SIZE = 5000

      CHART_BAR_MAX     = 20

      attr_accessor :params

      def initialize(params)
        @params = params

        @counts_hash = {}
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
          :real_total_count    => records.sum { |e| e[:count] || e["度数"] },
        }
      end

      private

      def aggregate_core
        loop_index = 0
        Swars::Membership.in_batches(of: BATCH_SIZE, order: :desc) do |s|
          if loop_index >= loop_max
            break
          end
          @sample_count += s.count
          tags = s.tag_counts_on("#{tactic_key}_tags")
          tags.each do |e|
            @counts_hash[e.name] ||= 0
            @counts_hash[e.name] += e.count
          end
          loop_index += 1
        end
        counts_hash_normalize
      end

      def to_h_with_processed_sec
        hash = {}
        processed_second = Benchmark.realtime { hash = to_h }
        hash.reverse_merge(processed_second: processed_second)
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
        Bioshogi::Explain::TacticInfo.fetch_if(tactic_key)
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
            if !max_list.include?(v)
              v = default_limit
            end
          end
          v
        end
      end

      def loop_max
        @loop_max ||= current_max.fdiv(BATCH_SIZE).ceil
      end

      def cache_key
        [self.class.name, tactic_key, current_max]
      end

      def aggregate_run
        second = Benchmark.realtime do
          aggregate_core
        end
        app_logging(second)
      end

      def app_logging(second)
        subject = "#{histogram_name}分布"
        body = { :ms => "%.1f s" % second }.merge(report_params)
        AppLog.info(subject: subject, body: body)
      end

      def report_params
        {
          :current_max  => current_max,
          :BATCH_SIZE   => BATCH_SIZE,
          :loop_max     => loop_max,
          :sample_count => @sample_count,
        }
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
          scales_y_axes_ticks: nil,
        }
      end

      def default_limit
        20000
      end

      def default_limit_max
        default_limit
      end

      def max_list
        if Rails.env.development?
          return [0, 1, 2, 1000, 5000, default_limit]
        end
        [5000, 10000, 20000]
      end

      def current_user
        params[:current_user]
      end

      def cache_expires_in
        2.hour
      end

      def counts_hash_normalize
        # タグにない戦法も抽出する場合
        if false
          @counts_hash = tactic_info.model.inject({}) { |a, e| a.merge(e.name => @counts_hash[e.name] || 0) } # => { "棒銀" => 3, "棒金" => 4, "風車" => 0 }
        end

        # いらんタグを消す場合
        if false
          if Rails.env.production? || Rails.env.staging? || Rails.env.test?
            Array(TagMethods.reject_tag_keys[tactic_key]).each do |e|
              @counts_hash.delete(e)
            end
          end
        end
      end
    end
  end
end
