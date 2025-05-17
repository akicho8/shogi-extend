# frozen-string-literal: true

module QuickScript
  module Swars
    class Aggregator
      include BatchMethods

      def initialize(options = {})
        @options = default_options.merge(options)
      end
    end
  end
end
