module Swars
  module Agent
    class IndexResult
      attr_accessor :keys
      attr_accessor :last_page

      class << self
        def empty
          new
        end
      end

      def initialize(keys: [], last_page: true)
        @keys = keys
        @last_page = last_page
      end

      def last_page?
        last_page
      end
    end
  end
end
