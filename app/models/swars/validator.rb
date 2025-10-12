module Swars
  class Validator
    class << self
      def valid?(...)
        new(...).public_send(__method__)
      end

      def invalid?(...)
        new(...).public_send(__method__)
      end

      def validate!(...)
        new(...).public_send(__method__)
      end

      def target_name
        raise NotImplementedError, "#{__method__} is not implemented"
      end

      def regexp
        raise NotImplementedError, "#{__method__} is not implemented"
      end
    end

    def initialize(value)
      @value = value.to_s
    end

    def valid?
      value.match?(/\A(?:#{self.class.regexp})\z/)
    end

    def invalid?
      !valid?
    end

    def validate!
      if invalid?
        raise InvalidKey, "#{self.class.target_name}ではありません : #{value.inspect}"
      end
    end

    private

    attr_reader :value
  end
end
