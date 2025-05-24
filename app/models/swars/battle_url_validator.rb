module Swars
  class BattleUrlValidator < Validator
    class << self
      def target_name
        "将棋ウォーズの対局URL"
      end

      def regexp
        %r{\bhttps://.*?\.heroz\.jp/games/#{BattleKeyValidator.regexp}}o
      end
    end
  end
end
