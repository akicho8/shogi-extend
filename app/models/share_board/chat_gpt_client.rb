module ShareBoard
  class ChatGptClient
    def initialize(topic, options = {})
      raise "must not happen" unless topic.kind_of?(Topic)
      @topic = topic
      @options = options
    end

    def call
      Rails.logger.debug { @topic.to_t }

      if @topic.present?
        SlackAgent.notify(subject: "ChatGPT", body: "[入力] #{@topic.last.content}", emoji: ":ChatGPT_IN:")
      end

      client = OpenAI::Client.new
      response = nil

      seconds = Benchmark.realtime do
        response = client.chat(
          parameters: {
            model: "gpt-3.5-turbo",
            messages: @topic.to_gpt_messages,
            # max_tokens: 0, # わざとエラーを出す場合
            temperature: 1.0,  # 1.5 にするとかなりアホになってしまう
          })
      end

      seconds = "[%.1f s]" % seconds
      Rails.logger.debug { response.pretty_inspect }

      if error_message = response.dig("error", "message")
        SlackAgent.notify(subject: "ChatGPT", body: "[ERROR]#{seconds} #{error_message.inspect}", emoji: ":ChatGPT_ERR:")
        return
      end

      text = response.dig("choices", 0, "message", "content")

      if text
        SlackAgent.notify(subject: "ChatGPT", body: "#{seconds} #{text.inspect}", emoji: ":ChatGPT_OUT:")
      end

      text
    end
  end
end
