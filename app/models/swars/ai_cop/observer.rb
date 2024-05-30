module Swars
  module AiCop
    class Observer
      class << self
        def parse(list)
          object = new
          list.each do |e|
            object.update(e)
          end
          object
        end

        def test(...)
          parse(...).to_h
        end
      end

      def update(...)
        raise NotImplementedError, "#{__method__} is not implemented"
      end

      def attributes_for_model
        {}
      end

      def to_h
        attributes_for_model
      end
    end
  end
end
