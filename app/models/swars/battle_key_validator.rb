module Swars
  class BattleKeyValidator < Validator
    class << self
      def target_name
        "将棋ウォーズの対局キー"
      end

      def regexp
        /#{UserKeyValidator.regexp}-#{UserKeyValidator.regexp}-#{timestamp_regexp}/o
      end

      def timestamp_regexp
        /\b\d{8}_\d{6}\b/o
      end
    end
  end
end
