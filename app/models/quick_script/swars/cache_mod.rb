module QuickScript
  module Swars
    concern :CacheMod do
      class_methods do
        def aggregate_cache
          AggregateCache[name]
        end
      end

      def cache_write
        aggregate_cache.write(aggregate_bm)
      end

      def cache_fetch
        aggregate_cache.fetch { aggregate_bm }
      end

      def cache_clear
        aggregate_cache.destroy_all
      end

      def aggregate
        @aggregate ||= aggregate_cache.read || aggregate_bm
      end

      def aggregate_bm
        Benchmarker.call("[#{self.class.name}]") { aggregate_now }
      end

      def aggregate_now
        {}
      end

      def aggregate_cache
        self.class.aggregate_cache
      end
    end
  end
end
