# ▼発言を返す
# rails r 'ShareBoard::Responder.new(message: "@gpt 将棋ウォーズの棋力は？").call'
module ShareBoard
  class Responder
    MATCH_REGEXP = /\s*@gpt\b\s*|\A\?\s*/i

    attr_accessor :params

    delegate :logger, to: :Rails

    def initialize(params = {})
      @params = {
        room_code: "dev_room",
      }.merge(params.symbolize_keys)
    end

    def call
      history << user_message
      if user_raw_message.match?(MATCH_REGEXP)
        topic = history.to_topic
        topic.unshift(system_message)
        text = ChatGptClient.new(topic).call
        if text
          history << Message.new(:assistant, text)
          logger.debug { history.to_topic.to_t }
          messanger.call(text)
        end
      end
    end

    private

    def room_code
      params[:room_code]
    end

    def messanger
      Messenger.new(messanger_options)
    end

    def history
      @history ||= MessageHistory.new(room_code: room_code)
    end

    def user_message
      Message.new(:user, user_raw_message.remove(MATCH_REGEXP))
    end

    def user_raw_message
      params[:message]
    end

    def message_scope_key
      params[:message_scope_key] || :is_message_scope_public
    end

    def system_message
      Message.new(:system, system_raw_message)
    end

    def system_raw_message
      "
あなたは将棋が大好きで現在は将棋ウォーズ4級ですが将来はプロ棋士を目指しています。
あなたは菅井竜也先生に憧れています。
あなたはウィットに富んだ会話のキャッチボールが得意です。
なるべく短い言葉で簡潔に話してください。
"
    end

    def messanger_options
      {
        :room_code         => room_code,
        :from_user_name    => "GPT",
        :primary_emoji     => "🤖",
        :message_scope_key => message_scope_key,
      }
    end
  end
end
