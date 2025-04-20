module QuickScript
  module Swars
    concern :CacheMod do
      def cache_write
        AggregateCache[self.class.name].write(aggregate_now)
      end

      def cache_fetch
        AggregateCache[self.class.name].fetch { aggregate_now }
      end

      def cache_clear
        AggregateCache[self.class.name].destroy_all
      end

      def aggregate
        @aggregate ||= AggregateCache[self.class.name].read || aggregate_now
      end

      def aggregate_now
        {}
      end
    end
  end
end
