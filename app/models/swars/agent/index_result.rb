module Swars
  module Agent
    class IndexResult
      attr_accessor :keys
      attr_accessor :last_page

      def self.empty
        r = new
        r.keys = []
        r.last_page = true
        r
      end

      def last_page?
        last_page
      end
    end
  end
end
