module ShareBoard
  module ChatAi
    class ChatAiClient
      class << self
        def text_normalize(text)
          text = text.strip
          text = text.remove(/。\z/)
          text = text.remove(/[「」]/) # ChatGPT はやたらと「○○」と表現するため「」を外す
        end
      end

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

        if !AppConfig[:ai_active]
          return
        end

        client = OpenAI::Client.new do |f|
          f.response :logger, Rails.logger, bodies: true
        end
        response = nil

        seconds = TimeTrial.second do
          response = client.chat(
            :parameters => {
              :model        => "gpt-4o", # https://platform.openai.com/docs/models
              :messages     => @topic.to_api_messages,
              # :max_tokens => 0,        # わざとエラーを出す場合
              :temperature  => 1.0,      # 1.5 にするとかなりアホになってしまう
            })
        end

        seconds = "[%.1f s]" % seconds
        Rails.logger.debug { response.pretty_inspect }

        # 昔はここでエラーが取れたが最近のは例外に変わった
        if error_message = response.dig("error", "message")
          AppLog.error(subject: "チャット (GPT)", body: "[ERROR]#{seconds} #{error_message.inspect}", emoji: ":ChatGPT_ERR:")
          return
        end

        text = response.dig("choices", 0, "message", "content")

        if text
          text = self.class.text_normalize(text)
        end

        if text
          AppLog.info(subject: "チャット (GPT)", body: "#{seconds} #{text.inspect}", emoji: ":ChatGPT_OUT:")
        end

        text
      rescue => error
        # https://platform.openai.com/docs/guides/error-codes/api-errors
        AppLog.error(subject: "チャット (GPT)", body: "[ERROR][例外] #{error}", emoji: ":ChatGPT_ERR:")
        nil
      end
    end
  end
end
