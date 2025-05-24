module Swars
  class UserKeyValidator < Validator
    class << self
      def target_name
        "将棋ウォーズのID"
      end

      def regexp
        /\b[a-zA-Z\d][a-zA-Z\d_]{2,14}\b/
      end
    end
  end
end
