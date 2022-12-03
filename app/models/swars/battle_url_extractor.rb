module Swars
  class BattleUrlExtractor
    def initialize(text)
      @text = text
    end

    def battle_url
      extract
    end

    private

    def extract
      if v = @text.slice(BattleUrlValidator::REGEXP)
        BattleUrl.new(v)
      end
    end
  end
end
