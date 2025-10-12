module Swars
  class BattleUrlValidator < Validator
    class << self
      def regexp
        %r{\bhttps://.*?\.heroz\.jp/games/#{BattleKeyValidator.regexp}}o
      end

      def target_name
        "将棋ウォーズの対局URL"
      end
    end
  end
end
