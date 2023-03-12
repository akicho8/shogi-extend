# -*- compile-command: "rails runner 'p ShareBoard::GptaiSimple.new(\"OK\").call'" -*-

module ShareBoard
  class GptaiSimple
    attr_accessor :user_text

    def initialize(user_text, options = {})
      @user_text = user_text
      @options = {
        topic: Topic[],
      }.merge(options)
    end

    def call
      ChatGptClient.new(topic, @options).call
    end

    def topic
      Topic[*@options[:topic], Message.new("user", @user_text)]
    end
  end
end
