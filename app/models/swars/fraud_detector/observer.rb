module Swars
  module FraudDetector
    class Observer
      class << self
        def parse(list)
          new.tap do |o|
            list.each { |e| o.update(e) }
          end
        end

        def test(...)
          parse(...).to_h
        end
      end

      def update(...)
        raise NotImplementedError, "#{__method__} is not implemented"
      end

      def db_attributes
        {}
      end

      def to_h
        db_attributes
      end
    end
  end
end
