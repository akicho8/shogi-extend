module Swars
  class UserKeyValidator < Validator
    class << self
      def target_name
        "将棋ウォーズのID"
      end

      def regexp
        /\b[a-zA-Z][a-zA-Z_]{2,14}\b/o
      end
    end
  end
end
