module Swars
  class BattleKeyValidator
    class InvalidKey < ArgumentError
    end

    class << self
      def valid?(key)
        new(key).valid?
      end

      def invalid?(key)
        new(key).invalid?
      end
    end

    def initialize(key)
      @key = key
    end

    def validate!
      if invalid?
        raise InvalidKey, "将棋ウォーズの対局キーではありません: #{key.inspect}"
      end
    end

    def valid?
      key.to_s.match?(/\A\w+-\w+-\d+_\d+\z/)
    end

    def invalid?
      !valid?
    end

    private

    attr_reader :key
  end
end
