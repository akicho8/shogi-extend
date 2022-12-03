module Swars
  class BattleUrlValidator
    REGEXP = %r{https://.*?\.heroz\.jp/games/#{BattleKeyValidator::REGEXP}}

    class InvalidKey < ArgumentError
    end

    attr_reader :url
    private :url

    def initialize(url)
      @url = url
    end

    def validate!
      if invalid?
        raise InvalidKey, "将棋ウォーズの対局URLではありません: #{url.inspect}"
      end
    end

    def valid?
      if url.present?
        url.match?(/\A(?:#{REGEXP})\z/)
      end
    end

    def invalid?
      !valid?
    end
  end
end
