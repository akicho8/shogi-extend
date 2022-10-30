module Swars
  module UserKeySuggestion
    class Main
      def initialize(user_key)
        @user_key = UserKey.new(user_key)
      end

      def message
        if command = Commands.find { |e| e[@user_key] }
          command[@user_key]
        end
      end
    end
  end
end
