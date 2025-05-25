module Swars
  class BattleUrlExtractor
    class << self
      def extract(...)
        new(...).extract
      end
    end

    def initialize(text)
      @text = text
    end

    def battle_url
      extract
    end

    def extract
      if v = @text.slice(BattleUrlValidator.regexp)
        BattleUrl.new(v)
      end
    end
  end
end
