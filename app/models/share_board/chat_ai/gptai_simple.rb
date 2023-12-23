# -*- compile-command: "rails runner 'p ShareBoard::ChatAi::GptaiSimple.new(\"OK\").call'" -*-

module ShareBoard
  module ChatAi
    class GptaiSimple
      attr_accessor :user_text

      def initialize(user_text, options = {})
        @user_text = user_text
        @options = {
          topic: Topic[],
        }.merge(options)
      end

      def call
        ChatAiClient.new(topic, @options).call
      end

      def topic
        Topic[*@options[:topic], Message.new(:user, @user_text)]
      end
    end
  end
end
