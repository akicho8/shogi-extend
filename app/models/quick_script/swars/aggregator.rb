# frozen-string-literal: true

module QuickScript
  module Swars
    class Aggregator
      include BatchMethods

      def initialize(options = {})
        @options = default_options.merge(options)
      end

      def call
        aggregate
      end
    end
  end
end
