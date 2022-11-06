module Swars
  module Agent
    class Base
      attr_accessor :params

      def initialize(params)
        @params = default_params.merge(params)
      end

      def default_params
        {}
      end

      def fetcher
        @fetcher ||= Fetcher.new(params) # remote_run, sleep を渡している
      end
    end
  end
end
