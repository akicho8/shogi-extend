module Swars
  module Importer
    class Base
      attr_accessor :params

      class << self
        def call(...)
          new(...).call
        end
      end

      def initialize(params = {})
        @params = default_params.merge(params)
      end

      def call
        raise NotImplementedError, "#{__method__} is not implemented"
      end

      def default_params
        {}
      end
    end
  end
end
