module Swars
  class UserKeyValidator
    REGEXP = /\b[a-zA-Z][a-zA-Z_]{2,14}\b/

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
        raise InvalidKey, "将棋ウォーズのIDではありません: #{key.inspect}"
      end
    end

    def valid?
      key.to_s.match?(/\A#{REGEXP}\z/)
    end

    def invalid?
      !valid?
    end

    private

    attr_reader :key
  end
end
