module ShareBoard
  module ChatAi
    class ChatAiClient
      def initialize(topic, options = {})
        raise "must not happen" unless topic.kind_of?(Topic)
        @topic = topic
        @options = options
      end

      def call
        Rails.logger.debug { @topic.to_t }

        if @topic.present?
          AppLog.info(subject: "チャット (GPT)", body: "[入力] #{@topic.last.content}", emoji: ":ChatGPT_IN:")
        end

        client = OpenAI::Client.new
        response = nil

        seconds = Benchmark.realtime do
          response = client.chat(
            parameters: {
              model: "gpt-4-0613",
              messages: @topic.to_api_messages,
              # max_tokens: 0, # わざとエラーを出す場合
              temperature: 1.0,  # 1.5 にするとかなりアホになってしまう
            })
        end

        seconds = "[%.1f s]" % seconds
        Rails.logger.debug { response.pretty_inspect }

        if error_message = response.dig("error", "message")
          AppLog.info(subject: "チャット (GPT)", body: "[ERROR]#{seconds} #{error_message.inspect}", emoji: ":ChatGPT_ERR:")
          return
        end

        text = response.dig("choices", 0, "message", "content")

        if text
          AppLog.info(subject: "チャット (GPT)", body: "#{seconds} #{text.inspect}", emoji: ":ChatGPT_OUT:")
        end

        text
      end
    end
  end
end
